require 'securerandom'

class User
  attr_reader :id, :name, :password

  def initialize(name, password)
    @name = name
    @password = password
    @id = SecureRandom.uuid
  end

  def ==(user)
    if @name == user.name && @password == user.password
        return true
    else 
        return false
    end
  end

  def to_s
    "#{@name}"
  end
end