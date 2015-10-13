class ApplicationService
  def perform
    raise NotImplementedError
  end

  def self.perform *args
    new(*args).perform
  end
end
