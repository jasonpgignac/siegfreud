class Audit < ActiveRecord::Base
  def self.columns() @columns ||= []; end
  def self.column(name, sql_type=nil,default=nil, null=true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end
  
  column :platform,   :string
  column :server_id,  :integer
  column :domain_id,  :integer
  column :site_id,    :integer
  
  belongs_to :server
  belongs_to :site
  belongs_to :domain
  
  validates_presence_of :platform, :server, :domain, :site
  
  def server_entries
    @server_entries ||= server.service_of_type("ComputerInformation",platform).info_for(site.site_maps.find_by_server_id(server.id))
  end
  def db_entries
    @db_entries ||= Computer.find_all_by_site_id(site_id, :conditions => {:system_class => platform, :domain_id => domain_id})
  end
  def combined_entries
    unless @combined_entries
      @combined_entries = Hash.new
      server_entries.each { |e| @combined_entries[e['serial_number']] ||= Hash.new; @combined_entries[e['serial_number'].downcase][:server] = e }
      db_entries.each { |e| @combined_entries[e.serial_number] ||= Hash.new; @combined_entries[e.serial_number.downcase][:db] = e }
    end
    return @combined_entries
  end
  def unmatched_server_entries
    combined_entries.clone.delete_if { |i,e| e[:db] }.map { |i,e| e[:server] }
  end
  def unmatched_db_entries
    combined_entries.clone.delete_if { |i,e| e[:server] }.map { |i,e| e[:db] }.delete_if { |e| !(e.stage.has_deployment) }
  end
  def matched_entries
    combined_entries.clone.delete_if { |i,e| !(e[:server]) }.delete_if { |i,e| !(e[:db]) }
  end
  def entry_conflicts
    unless @entry_conflicts
      @entry_conflicts = matched_entries.each do |x, e|
        e[:errors] = Array.new
        unless e[:db].stage.has_deployment
          e[:errors] << "Deployment status mismatch"
        else
          e[:errors] << "Name mismatch" unless e[:db].name.downcase == e[:server]['name'].to_s.downcase
          e[:errors] << "Domain mismatch" unless e[:db].domain.name.downcase == e[:server]['domain'].to_s.downcase || e[:db].domain.bare_name.downcase == e[:server]['domain'].downcase
          e[:errors] << "Owner mismatch" unless e[:db].owner.downcase == e[:server]['user'].to_s.downcase
        end
      end
      @entry_conflicts.delete_if{ |x,e| e[:errors].size == 0}
    end
    return @entry_conflicts
  end
end

