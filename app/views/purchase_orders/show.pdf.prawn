pdf.text "PO: ##{@purchase_order.po_number}", :size => 18, :style => :bold
licenses = @purchase_order.licenses.map do |lic|
  [
    lic.short_name.to_s,
    lic.division.display_name,
    lic.current_location,
    lic.license_key.to_s
  ]
end
peripherals = @purchase_order.peripherals.map do |periph|
  [
    periph.model.to_s,
    periph.serial_number.to_s,
    periph.division.display_name,
    periph.current_location
  ]
end
computers = @purchase_order.computers.map do |computer|
  [
    computer.model.to_s,
    computer.serial_number.to_s,
    computer.division.display_name,
    computer.current_location.to_s
  ]
end
pdf.move_down 20
pdf.text "Current Status", :size => 14, :style => :bold
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

unless(computers.nil? || computers.empty?)
  pdf.move_down 20
  pdf.text "Computers", :size => 14, :style => :bold
  pdf.table computers,
      :border_style => :grid,
      :row_colors => ["FFFFFF", "DDDDDD"],
      :font_size => 6
end