class Tabset < ActiveRecord::Base
  has_many :tabs, :order => :position, :dependent => :destroy;
  belongs_to :active_tab, :class_name => "Tab";
  
  def switch_to_next_tab
    unless(self.active_tab.last?)
      next_tab = self.active_tab.lower_item;
    else
      next_tab = self.active_tab.higher_item
    end
    self.active_tab = next_tab;
    self.save;
  end
  
  def find_open_tab_for_content(tab_content)
    self.tabs.find_by_content_type(tab_content.class.to_s, :conditions => ["content_id = ?", tab_content.content_id])
  end
  
  def open(tab_content)
    tab = find_open_tab_for_content(tab_content)
    unless(tab)
      tab = self.tabs.create()
      tab.content=tab_content
      tab.save
    end
    logger.info { "Tab id : " + tab.id.to_s }
    return tab;
  end
  
  def open_and_activate(tab_content)
    tab = (self.open(tab_content));
    self.active_tab=(self.open(tab_content))
    self.save;
  end
  
end