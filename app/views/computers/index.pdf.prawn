title = "Computers" + (@division ? ": #{@division.display_name}" : "")
pdf.text title, :size => 18, :style => :bold
computers = @computers.map do |computer|
  [
    computer.model.to_s,
    computer.serial_number.to_s,
    computer.division.display_name,
    computer.current_location.to_s
  ]
end
pdf.move_down 20
pdf.text "Current Status", :size => 14, :style => :bold

unless(computers.nil? || computers.empty?)
  pdf.move_down 20
  pdf.text "Computers", :size => 14, :style => :bold
  pdf.table computers,
      :border_style => :grid,
      :row_colors => ["FFFFFF", "DDDDDD"],
      :font_size => 6
end