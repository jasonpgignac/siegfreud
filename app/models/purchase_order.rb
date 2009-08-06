class PurchaseOrder < ActiveRecord::BaseWithoutTable
  column :po_number, :string
  column :division, :string

  validates_presence_of :po_number, :division
  
  def computers
    Computer.find_all_by_po_number(self.po_number)
  end
  def peripherals
    Peripheral.find_all_by_po_number(self.po_number)
  end
  def licenses
    License.find_all_by_po_number(self.po_number)
  end

end