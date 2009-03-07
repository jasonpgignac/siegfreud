require 'openssl'
# Originally from Brent Sowers @ http://brentrubyrails.blogspot.com/2007/12/aes-encryption-and-decryption-in-ruby.html
# Edited on Feb 13, 2009, to limit to AES-256-CBC, for convenience

module AESCrypt
  # Decrypts a block of data (encrypted_data) given an encryption key
  # and an initialization vector (iv).  Keys, iv's, and the data 
  # returned are all binary strings.  Cipher_type should be
  # "AES-256-CBC", "AES-256-ECB", or any of the cipher types
  # supported by OpenSSL.  Pass nil for the iv if the encryption type
  # doesn't use iv's (like ECB).
  #:return: => String
  #:arg: encrypted_data => String 
  #:arg: key => String
  #:arg: iv => String
  #:arg: cipher_type => String
  def AESCrypt.decrypt(encrypted_data, key, iv)
    aes = OpenSSL::Cipher::Cipher.new("AES-256-CBC")
    aes.decrypt
    key = Digest::SHA1.hexdigest(key)
    aes.key = key
    aes.iv = iv
    aes.update(encrypted_data) + aes.final  
  end
  
  # Encrypts a block of data given an encryption key and an 
  # initialization vector (iv).  Keys, iv's, and the data returned 
  # are all binary strings.  Cipher_type should be "AES-256-CBC",
  # "AES-256-ECB", or any of the cipher types supported by OpenSSL.  
  # Pass nil for the iv if the encryption type doesn't use iv's (like
  # ECB).
  #:return: => String
  #:arg: data => String 
  #:arg: key => String
  #:arg: iv => String
  #:arg: cipher_type => String  
  def AESCrypt.encrypt(data, key, iv)
    aes = OpenSSL::Cipher::Cipher.new("AES-256-CBC")
    aes.encrypt
    key = Digest::SHA1.hexdigest(key)
    aes.key = key
    aes.iv = iv
    aes.update(data) + aes.final
  end
  
  def AESCrypt.random_iv
    c = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
    c.encrypt
    return c.random_iv
  end
end