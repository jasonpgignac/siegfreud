class SoftwareManagementService < MashupService
  def get_advertisements_for_computer(serial)
    url = URI.parse(self.address + "computers/#{serial}/advertisements.json")
    advertisements = self.get(url)
  end
  def push_task_to_computer(package_id, task_id, serial)
    url = URI.parse(self.address + "computers/#{serial}/advertisements.json")
    params = {"advertisement" => {"task_name" => task_id, "package_id" => package_id}}
    advertisements = self.post(url, params)
  end
end
