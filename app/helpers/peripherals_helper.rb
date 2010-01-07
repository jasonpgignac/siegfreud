module PeripheralsHelper
  def peripheral_stage_change
    "var stage_id=document.getElementById('peripheral_stage_id').value;

    if(stage_id == 0) {
      document.getElementById('deployment_data').hide();
      document.getElementById('location_data').hide();
      document.getElementById('computer_data').show();
    } else {
      document.getElementById('computer_data').hide();
      if (#{needs_deployment_form}) {
    	  document.getElementById('deployment_data').show();
      } else {
      	document.getElementById('deployment_data').hide();
      }

      if (#{needs_location_form}) {
      	document.getElementById('location_data').show();
      } else {
      	document.getElementById('location_data').hide();
      }
    }"
  end
  def needs_location_form
    stages = Stage.find_all_by_has_location(true)
    stages.collect! do |stage|
      "stage_id == '#{stage.id}'"
    end
    return stages.join(" || ")
  end
  def needs_deployment_form
    stages = Stage.find_all_by_has_deployment(true)
    stages.collect! do |stage|
      "stage_id == '#{stage.id}'"
    end
    return stages.join(" || ")
  end
end
