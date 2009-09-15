pdf.text "Computer Manifest: ##{@computer.short_name}", :size => 18, :style => :bold
licenses = @computer.licenses.map do |lic|
  [
    lic.short_name.to_s,
    lic.license_key.to_s
  ]
end
peripherals = @computer.peripherals.map do |periph|
  [
    periph.model.to_s,
    periph.serial_number.to_s
  ]
end

pdf.move_down 20
pdf.text "General Info", :size => 14, :style => :bold
pdf.text "Serial: #{@computer.serial_number}", :size => 8
pdf.text "Model: #{@computer.model}", :size => 8
pdf.text "System Class: #{@computer.system_class}", :size => 8 
pdf.text "Mac Address: #{@computer.mac_address}", :size => 8
pdf.text "PO Number: #{@computer.po_number}", :size => 8
pdf.text "Division: #{@computer.division.display_name}", :size => 8
pdf.text "Last Audited: #{@computer.last_audited.to_s}", :size => 8	

pdf.move_down 20
pdf.text "Current Status", :size => 14, :style => :bold
pdf.text "Stage: #{@computer.stage}", :size => 8
if (@computer.stage != "Storage" && @computer.stage != "Disposal")
	pdf.text "Owner: #{@computer.owner}"
	pdf.text "System Role:  #{@computer.system_role}"
	pdf.text "Name: #{@computer.name}"
  pdf.text "Domain: #{@computer.domain}"
end
unless(licenses.nil? || licenses.empty?)
  pdf.move_down 20
  pdf.text "Licenses", :size => 14, :style => :bold
  pdf.table licenses,
      :border_style => :grid,
      :row_colors => ["FFFFFF", "DDDDDD"],
      :font_size => 6
end      

unless(peripherals.nil? || peripherals.empty?)
  pdf.move_down 20
  pdf.text "Peripherals", :size => 14, :style => :bold
  pdf.table peripherals,
      :border_style => :grid,
      :row_colors => ["FFFFFF", "DDDDDD"],
      :font_size => 6
end