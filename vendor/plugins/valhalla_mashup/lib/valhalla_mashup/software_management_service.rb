module ValhallaMashup
  class SoftwareManagementService < MashupService
    def info_for(content)
      if content.class == Computer
        computer_key = eval("content.#{@computer_key_field}")
        self.get("computers/#{computer_key}/advertisements.json")
      end
    end
    def advertisements_for_computer(serial)
      advertisements = self.get("computers/#{serial}/advertisements.json")
    end
    def push_task_to_computer(package_id, task_id, serial)
      path = ("computers/#{serial}/advertisements.json")
      params = {"advertisement" => {"task_name" => task_id, "package_id" => package_id}}
      advertisements = self.post(path, params)
    end
  end
  
end