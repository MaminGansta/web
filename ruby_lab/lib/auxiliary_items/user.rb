# frozen_string_literal: true

require 'securerandom'

# discride user
class User
  attr_reader :id, :name, :password

  def initialize(name, password)
    @name = name
    @password = password
    @id = SecureRandom.uuid
    @session_ids = []
  end

  def ==(other)
    if @name == other.name && @password == other.password
      true
    else
      false
    end
  end

  def to_s
    @name.to_s
  end
end
