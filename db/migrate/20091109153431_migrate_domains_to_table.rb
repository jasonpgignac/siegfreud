class MigrateDomainsToTable < ActiveRecord::Migration
  def self.up
	rename_column :computers, :domain, :old_domain
	Computer.all.each do |c|
		if (c.old_domain && !(c.old_domain.empty?))
		  puts "Testing #{c.old_domain.upcase}"
		  d = Domain.find_by_name(c.old_domain.upcase)
		  if(d.nil?)
		    puts "Domain doesn't exist, will create it now."
			  d = Domain.new
			  d.name = c.old_domain.upcase
			  d.save
			  puts "Saved"
			else
			  puts "Record already exists"
		  end
		  c.domain = d
		  puts "Domain is set"
		  c.save
		  puts "Record Saved"
		end
	end
	remove_column :computers, :old_domain
  end

  def self.down
	add_column :computers, :old_domain
	Computer.all.each do |c|
		c.old_domain = c.domain.name
		c.domain = nil
		c.save
	end
	rename_column :computers, :old_domain, :domain
  end
end
