class SmsPackage < ActiveRecord::Base
    include SmsRestCall
    include SmsObject
    extend SmsObjectClassMethods
    
    belongs_to :content_server;
    has_many :package_deployments,
             :class_name => "SmsPackageDeployment",
             :foreign_key => "package_id"
    has_many :tasks,
              :class_name => "SmsTask",
              :foreign_key => "package_id",
              :dependent  =>  :destroy
              
    
    def to_s
      "SMS Package " + self.remote_id
    end

    def ==(otherSmsPackage)
      return ((self.remote_id == otherSmsPackage.remote_id) && (@server == otherSmsPackage.server))
    end

    def short_name
      self.manufacturer + " " + self.name + " " + self.version
    end
    def manufacturer
      unless (super && ((Date.today - self.last_cached) < 3))
        refreshAttributes
      else
      end
      super
    end
    def name
      unless (super && ((Date.today - self.last_cached) < 3))
        refreshAttributes
      else
      end
      super
    end
    def version
      unless (super && ((Date.today - self.last_cached) < 3))
        refreshAttributes
      else
      end
      super
    end
    def refreshAttributes
      doc = sms_rest_call("getDetailsForPackage", {"id" => self.remote_id.to_s})
      searchResponse = doc.elements["smsRestPackageRecord"]
      resultsArray = []
      self.manufacturer = searchResponse.elements['manufacturer'].get_text.to_s
      self.name = searchResponse.elements['name'].get_text.to_s
      self.version = searchResponse.elements['version'].get_text.to_s
      searchResponse.elements.each("program") do |program|
        newTask = SmsTask.new
        newTask.name = program.get_text.to_s
        newTask.package_id = self.id
        newTask.save
      end
      self.last_cached = Date.today
      self.save
    end
    def content_id
      self.remote_id
    end
    def template_class
      return "package"
    end
    def tasks
      tasks = SmsTask.find_all_by_package_id(id)
      if (tasks.size > 0 && ((Date.today - self.last_cached) < 3))
        puts "Yay! Found some!"
        return tasks
      else
        self.refreshAttributes
        taskList = SmsTask.find_all_by_package_id(id)
        return taskList
      end
    end
end
