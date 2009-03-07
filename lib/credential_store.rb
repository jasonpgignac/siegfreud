module CredentialStore
  
  def cs_set_credentials(name, new_username, new_password)
    self.iv
    self.server_nonce
    self.customer_nonce
    session[:cs_store][name] ||= Hash.new()
    session[:cs_store][name][:password] = AESCrypt.encrypt(new_password, self.customer_nonce, self.iv)
    session[:cs_store][name][:username] = new_username
  end
  def cs_credentials(name)
    unless session[:cs_store] && 
            session[:cs_store][name]
      password = (session[:cs_store] && session[:cs_store][:default]) ?  session[:cs_store][:default][:password] : nil
      username = (session[:cs_store] && session[:cs_store][:default]) ?  session[:cs_store][:default][:username] : nil
    else
      password = AESCrypt.decrypt(session[:cs_store][name][:password], self.customer_nonce, self.iv)
      username = session[:cs_store][name][:username]
    end
    return {:username => username, :password => password}
  end
  def cs_reset
    session[:cs_store] = Hash.new()
    session[:cs_iv] = nil
    session[:cs_server_nonce] = nil
    cookies[:cs_encrypted_customer_nonce] = nil
    @reset_customer_nonce = true
  end
  def cs
    store = Hash.new()
    session[:cs_store].each do |key, value|
      this_item = Hash.new()
      credentials = self.cs_credentials(key)
      this_item[:password] = credentials[:password]
      this_item[:username] = credentials[:username]
      store[key] = this_item
    end
    return store
  end

  
  protected
  
  def iv
    unless session[:cs_iv]
      session[:cs_store] = Hash.new()
      cookies[:cs_encrypted_customer_nonce] = nil
      session[:cs_iv] = AESCrypt.random_iv
      puts "Resetting the IV"
    end
    return session[:cs_iv]
  end
  def server_nonce
    unless session[:cs_server_nonce]
      session[:cs_store] = Hash.new()
      cookies[:cs_encrypted_customer_nonce] = nil 
      session[:cs_server_nonce] = generate_random_string(24)
      puts "Resetting the Server nonce"
    end
    return session[:cs_server_nonce]
  end
  def customer_nonce
    unless ((cookies[:cs_encrypted_customer_nonce] || @encrypted_customer_nonce) && !(@reset_customer_nonce))
      session[:cs_store] = Hash.new()
      puts "Setting Customer Nonce"
      puts "IV : " + self.iv
      puts "Server Nonce : " + self.server_nonce
      @encrypted_customer_nonce = AESCrypt.encrypt(generate_random_string(24), self.server_nonce, self.iv)
      puts "Encrytped_customer_nonce : " + @encrypted_customer_nonce
      cookies[:cs_encrypted_customer_nonce] = @encrypted_customer_nonce
      @reset_customer_nonce = false
    end
    @encrypted_customer_nonce ||= cookies[:cs_encrypted_customer_nonce]
    puts "Encrypted Customer Nonce : " + @encrypted_customer_nonce
    return AESCrypt.decrypt(@encrypted_customer_nonce, self.server_nonce, self.iv)
  end
  def generate_random_string(length)
    string = ""
    chars = ("A".."Z").to_a
    length.times do
      string << chars[rand(chars.length-1)]
    end
    string
  end
end