class PurchaseOrdersController < ApplicationController
  def new
    @purchase_order = PurchaseOrder.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @action }
    end
  end
  def create
    @purchase_order = PurchaseOrder.new(params[:purchase_order])

    respond_to do |format|
      if @purchase_order.save
        flash[:notice] = 'Purchase Order was successfully created.'
        @division = Division.find(@purchase_order.division_id)
        format.html { redirect_to(edit_purchase_order_path(:id => @purchase_order.po_number, :division_id => @purchase_order.division_id)) }
        format.xml  { render :xml => @purchase_order, :status => :created, :location => @purchase_order }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @purchase_order.errors, :status => :unprocessable_entity }
      end
    end
  end
  def show
    @purchase_order = PurchaseOrder.new()
    @purchase_order.po_number = params[:id]
    @purchase_order.division_id = @division
    @purchase_order.division_id ||= params[:division_id]
    respond_to do |format|
      #format.html # show.html.erb
      #format.xml  { render :xml => @purchase_order }
      format.pdf
    end
  end
  def edit
    @purchase_order = PurchaseOrder.new()
    @purchase_order.po_number = params[:id]
    @purchase_order.division_id ||= params[:division_id]
    @division = Division.find(@purchase_order.division_id)
  end
  
  # Edit Actions (Associated objects)
  def edit_peripheral
    refresh_po_instance(params[:po_number], params[:division_id])
    @periph = Peripheral.find(params[:id])
    row_id = "new_periph_" + @periph.id.to_s
    update_page do |page|
      page.set_redbox('edit_peripheral_form')
    end
  end
  def save_edited_peripheral
    refresh_po_instance(params[:po_number], params[:division_id])
    if params.key?(:id)    
      @periph = Peripheral.find(params[:id])
      @periph.edit_with_params(params[:peripheral])
      flash[:notice] = 'Peripheral was successfully updated.'
    else
      Peripheral.create_with_po(@purchase_order, params[:peripheral])
      flash[:notice] = 'Peripheral was successfully created.'
    end
    update_page do |page|
      page.close_redbox
      page.redraw_new_peripherals
    end  
  end
  def delete_peripheral_from_po
    refresh_po_instance(params[:po_number], params[:division_id])
    Peripheral.find(params[:id]).delete
    update_page do |page|
      page.redraw_new_peripherals
    end
  end
  
  def make_new_license_in_po
    refresh_po_instance(params[:po_number], params[:division_id])
    update_page do |page|
      page.set_redbox('new_license_form')
    end
  end
  def confirm_new_license
    refresh_po_instance(params[:po_number], params[:division_id])
    @quantity = params[:quantity]
    packages = Package.search(params[:search_string])
    @select_options = ""
    packages.each do |pkg|
      @select_options = @select_options + "<option value=\"" + pkg.id.to_s + "\">" + pkg.short_name + "</option>"
    end
    @group_license = true
    update_page do |page|
      page.switch_to_package_search_results_in_redbox
    end
  end
  def change_new_licenses_state
    
    @quantity = params[:quantity]
    @group_license = params[:group_license]
    update_page do |page|
      page.update_new_license_licensing
    end
  end
  def save_new_license
    refresh_po_instance(params[:po_number], params[:division_id])
    pkg = Package.find(params[:package_id])
    quantity = params[:quantity]
    group_license = params[:group_license]
    
    quantity.to_i.times do |i|
      lic_params = {
        :package_id => pkg.id,
        :group_license => (group_license ? true : false ),
        :group_license => (group_license ? params['license_number'] : params['license_number_' + (i + 1).to_s] )
      }
      License.create_with_po(@purchase_order, lic_params)
    end  
    flash[:notice] = "Licenses were successfully created."
    update_page do |page|
      page.close_redbox
      page.redraw_new_licenses
    end
  end
  def delete_license_from_po
    refresh_po_instance(params[:po_number], params[:division_id])
    License.find_all_by_po_number(@purchase_order.po_number, :conditions => ["package_id = ?", params[:id]]).each do |lic|
      lic.delete
    end
    update_page do |page|
      page.redraw_new_licenses
    end
  end
  
  def make_new_bundle_in_po
    refresh_po_instance(params[:po_number], params[:division_id])
    @bundles = Array.new()
    Bundle.find(:all).each do |bndl|
      @bundles << [bndl.name, bndl.id]
    end
    update_page do |page|
      page.set_redbox('new_bundle_form')
    end
  end
  def save_new_bundle
    refresh_po_instance(params[:po_number], params[:division_id ])
    bundle_to_add = Bundle.find(params[:id])
    quantity = params[:quantity]
    bundle_to_add.packages.each do |pkg|
      quantity.to_i.times do
        lic_params = {
          :package_id => pkg.id,
          :group_license => true
        }
        License.create_with_po(@purchase_order, lic_params)
      end
    end
    update_page do |page|
      page.close_redbox
      page.redraw_new_licenses
    end
  end
  
  # Edit Actions (Display)
  def update_page
    render :update do |page|
      def page.update_new_license_licensing
        page.replace_html 'new_license_licensing', :partial => 'new_license_licensing'
      end
      def page.switch_to_package_search_results_in_redbox
        page.replace_html 'licensing_redbox_form', :partial => 'new_license_confirm_form'
      end
      def page.redraw_new_computers
        page.replace_html 'new_computers', :partial => 'computers_in_po'
      end
      def page.redraw_new_peripherals
        page.replace_html 'new_peripherals', :partial => 'peripherals_in_po'
      end
      def page.redraw_new_licenses
        page.replace_html 'new_licenses', :partial => 'licenses_in_po'
      end
      def page.set_redbox(redbox_partial)
        page << "RedBox.showInline('hidden_content_alert')"
        page.replace_html "hidden_content_alert", :partial => redbox_partial
      end
      def page.close_redbox
        page << "RedBox.close()"
      end
      def page.hide_spinner
        page << "$('spinner').hide();"
      end
      
      yield(page)
    end
  end
  def refresh_po_instance(po_number, division_id)
    @purchase_order = PurchaseOrder.new
    @purchase_order.po_number = po_number
    @purchase_order.division_id = division_id
  end
    
end
