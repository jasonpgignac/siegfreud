
when  ["Storage", "Rollout"],
      ["Active", "Repair"],
      ["Storage", "Active"],
["Rollout", "Active"]
  test_deployment_data(attributes)
when  ["Rollout", "Storage"],
      ["Rollout", "Disposal"],
      ["Active", "Storage"],
      ["Active", "Disposal"],
      ["Repair", "Storage"],
      ["Retrieval", "Storage"],
      ["Retrieval", "Disposal"],
      ["Active", "Retrieval"],
      ["Rollout", "Retrieval"],
      ["Disposal", "Storage"],
["Storage", "Disposal"]
  test_location_data(attributes)
when  ["Storage", "Retrieval"],
      ["Active", "Rollout"],
      ["Retrieval", "Rollout"],
      ["Retrieval", "Active"],
      ["Disposal", "Rollout"],
      ["Disposal", "Active"],
      ["Disposal", "Retrieval"]
  illegal_transition_error
else
  illegal_transition_error
end
case [self.stage, new_stage]
when  ["Rollout", "Storage"],
      ["Rollout", "Disposal"],
      ["Active", "Storage"],
      ["Active", "Disposal"],
      ["Repair", "Storage"],
      ["Retrieval", "Storage"],
      ["Retrieval", "Disposal"]
  clear_deployment_data
  clear_licensing_and_peripherals
end