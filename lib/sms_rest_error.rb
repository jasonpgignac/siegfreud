class SmsRestError < RuntimeError
  attr :rest_url
  def initialize (url)
    @rest_url = url
  end
end

class SmsServerUnavailable < RuntimeError
end

class SmsObjectCreationFailDuplicateName < SmsRestError
end
class SmsObjectNotFound < SmsRestError
end
class SmsInvalidQueryParameters < SmsRestError
end
class SmsGenericRuntimeError < SmsRestError
end
class SmsGenericUnknownError < SmsRestError
end
