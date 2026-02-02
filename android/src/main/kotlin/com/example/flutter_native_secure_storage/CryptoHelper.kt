package com.example.flutter_native_secure_storage

import android.content.Context
import android.content.SharedPreferences
import android.os.Build
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import android.util.Base64
import java.security.KeyStore
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.GCMParameterSpec

private const val ANDROID_KEYSTORE = "AndroidKeyStore"
private const val KEY_ALIAS = "flutter_secure_master_key"
private const val TRANSFORMATION = "AES/GCM/NoPadding"
private const val IV_SIZE = 12
private const val TAG_SIZE = 128

class CryptoHelper(context: Context) {

    private val prefs: SharedPreferences =
        context.getSharedPreferences("secure_storage", Context.MODE_PRIVATE)

    private val keyStore: KeyStore =
        KeyStore.getInstance(ANDROID_KEYSTORE).apply { load(null) }

    // 🔑 Create or get AES key from Android Keystore
    private fun getOrCreateSecretKey(): SecretKey {
        if (keyStore.containsAlias(KEY_ALIAS)) {
            return keyStore.getKey(KEY_ALIAS, null) as SecretKey
        }

        val keyGenerator = KeyGenerator.getInstance(
            KeyProperties.KEY_ALGORITHM_AES,
            ANDROID_KEYSTORE
        )

        val keySpec = KeyGenParameterSpec.Builder(
            KEY_ALIAS,
            KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT
        )
            .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
            .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
            .setKeySize(256)
            .build()

        keyGenerator.init(keySpec)
        return keyGenerator.generateKey()
    }

    // 🔐 Encrypt & store
    fun encryptAndStore(key: String, value: String) {
        val cipher = Cipher.getInstance(TRANSFORMATION)
        cipher.init(Cipher.ENCRYPT_MODE, getOrCreateSecretKey())

        val encryptedBytes = cipher.doFinal(value.toByteArray(Charsets.UTF_8))
        val iv = cipher.iv

        val combined = ByteArray(iv.size + encryptedBytes.size)
        System.arraycopy(iv, 0, combined, 0, iv.size)
        System.arraycopy(encryptedBytes, 0, combined, iv.size, encryptedBytes.size)

        prefs.edit()
            .putString(
                key,
                Base64.encodeToString(combined, Base64.NO_WRAP)
            )
            .apply()
    }

    // 🔓 Decrypt
    fun decrypt(key: String): String? {
        val encrypted = prefs.getString(key, null) ?: return null
        val decoded = Base64.decode(encrypted, Base64.NO_WRAP)

        val iv = decoded.copyOfRange(0, IV_SIZE)
        val cipherText = decoded.copyOfRange(IV_SIZE, decoded.size)

        val cipher = Cipher.getInstance(TRANSFORMATION)
        cipher.init(
            Cipher.DECRYPT_MODE,
            getOrCreateSecretKey(),
            GCMParameterSpec(TAG_SIZE, iv)
        )

        val decryptedBytes = cipher.doFinal(cipherText)
        return String(decryptedBytes, Charsets.UTF_8)
    }

    // 🗑 Delete single key
    fun delete(key: String) {
        prefs.edit().remove(key).apply()
    }

    // 🧹 Clear all
    fun clear() {
        prefs.edit().clear().apply()
    }
}
