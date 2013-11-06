class UsersController < ApplicationController

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(params[:user])  
  	@user.role = "reader"
  	if @user.save
  		puts "Signup successfull"
  		flash[:notice] = "Signup was successfull"
  		redirect_to @user
  	else
  		puts "Signup Unsuccessfull"
  		flash[:error] = "Unable to signup, invalid username or password"
  		render 'new'
  	end
  end

  def show
    @user = User.find(params[:id])
    if @user.role=="writer"
      @stateName = State.pluck(:name);  
      render 'writer_show.html.erb'
    else
      @touristSpots = TouristSpot.all
      @hotels = Hotel.all
      @entryPoints = EntryPoint.all

      @json1 = TouristSpot.all.to_gmaps4rails do |touristSpot, marker|
        # marker.infowindow render_to_string(:partial => "/touristSpots/infowindow", :locals => { :touristSpot => touristSpot})
        marker.picture({:picture => "../../assets/marker.png",
          :width => 32,
          :height => 32})
        marker.title "#{touristSpot.name}"
        marker.json({ :id => touristSpot.id,:type => 'parent'})
      end

      @json2 = Hotel.all.to_gmaps4rails do |hotel, marker|
        marker.infowindow render_to_string(:partial => "/hotels/infowindow", :locals => { :hotel => hotel})
        marker.picture({:picture => "../../assets/hotel.png",
          :width => 32,
          :height => 32})
        marker.title "#{hotel.name}"
        marker.json({ :id => hotel.id, :type => 'parent'})
      end

      @json3 = EntryPoint.all.to_gmaps4rails do |entryPoint, marker|
        marker.infowindow render_to_string(:partial => "/entryPoints/infowindow", :locals => { :entryPoint => entryPoint})
        mode = "airplane"
        if entryPoint.entryType==1
          mode="railway"
        end
        marker.picture({:picture => "../../assets/" + mode + ".png",
          :width => 32,
          :height => 32})
        marker.title "#{entryPoint.name}"
        marker.json({ :id => entryPoint.id, :type => 'parent'})

      end

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @touristSpots }
      end
      # render 'show.html.erb'
    end
  end

  def show_closer_to
    tid = params[:tid]
    # puts params[:controller].keys
    # puts "id in (select local_transport_stand_id from closer_tos where tourist_spot_id=#{id})"
    @ltsCloserTo =  LocalTransportStand.where("id in (select local_transport_stand_id from closer_tos where tourist_spot_id=#{tid})").all.to_gmaps4rails do |localTransportStand, marker|
      # marker.infowindow render_to_string(:partial => "/localTransportStand/infowindow", :locals => { :localTransportStand => localTransportStand})
      marker.picture({:picture => "../../assets/" +localTransportStand.localTransport + ".png",
        :width => 32,
        :height => 32})
      marker.title "#{localTransportStand.name}"
      marker.json({ :id => localTransportStand.id, :type => 'child'})
    end

    respond_to do |format|
      format.html
      format.json { render :json => @ltsCloserTo }
    end    
  end
  

    def writer_district
    @user = User.find(params[:id])
    if params[:SN1] # ADD NEW STATE
      if State.exists?(:name=>params[:SN1])
        flash[:notice] = "State already exists"
      else
        s=State.create(:name=>params[:SN1])
        m1=MapPoint.create(:latitude=>params[:TLLat1], :longitude=>params[:TLLong1])
        m2=MapPoint.create(:latitude=>params[:BRLat1], :longitude=>params[:BRLong1])
        StateBoundedBy.create(:state_id=>s.id, :top_left_corner_id=>m1.id, :bottom_right_corner_id=>m2.id)
      end
      @stateName = State.where(:name=>params[:SN1])[0].name
      session[:stateName]=@stateName
    elsif params[:SN2] # ADD TO EXISTING STATE
      unless State.exists?(:name=>params[:SN2])
        flash[:error] = "State didn't already exist ! Add a new state"
        redirect_to "/users/#{params[:id]}"
      else
        @stateName = State.where(:name=>params[:SN2])[0].name
        session[:stateName]=@stateName
      end
    elsif params[:SN3] # MODIFY EXISTING AND ADD TO IT
      if State.exists?(:name=>params[:SN3])
        s = State.where(:name=>params[:SN3])[0]
        sbb=StateBoundedBy.where(:state_id=>State.where(:name=>params[:SN3])[0].id)[0]
        if !sbb.nil?
          sbb.destroy
        end
        m1=MapPoint.create(:latitude=>params[:TLLat3], :longitude=>params[:TLLong3])
        m2=MapPoint.create(:latitude=>params[:BRLat3], :longitude=>params[:BRLong3])
        StateBoundedBy.create(:state_id=>s.id, :top_left_corner_id=>m1.id, :bottom_right_corner_id=>m2.id)
        @stateName = s.name
        session[:stateName]=@stateName
      else
        flash[:error]="State doesn't exist"
        redirect_to "/users/#{params[:id]}"
      end
    end
    @districtName = District.where(:state_id=>State.where(:name=>session[:stateName])[0].id).pluck(:name);
  end


  def writer_final
    @user = User.find(params[:id])
    stateIdNow = State.where(:name=>session[:stateName])[0].id
    if params[:DN1] # ADD NEW DISTRICT
      if District.exists?(:name=>params[:DN1], :state_id=>stateIdNow)
        flash[:notice] = "District already exists"
      else
        d=District.create(:name=>params[:DN1], :state_id=>stateIdNow)
        m1=MapPoint.create(:latitude=>params[:TLLat1], :longitude=>params[:TLLong1])
        m2=MapPoint.create(:latitude=>params[:BRLat1], :longitude=>params[:BRLong1])
        DistrictBoundedBy.create(:district_id=>d.id, :top_left_corner_id=>m1.id, :bottom_right_corner_id=>m2.id)
      end
      session[:districtName]=params[:DN1]
    elsif params[:DN2] # ADD TO EXISTING STATE
      unless District.exists?(:name=>params[:DN2], :state_id=>stateIdNow)
        flash[:error] = "district didn't already exist !Get its location info Add a new district"
        redirect_to "/users/#{@user.id}/writer_district"
      else
        session[:districtName]=params[:DN2]
      end
    elsif params[:DN3] # MODIFY EXISTING AND ADD TO IT
      if District.exists?(:name=>params[:DN3], :state_id=>stateIdNow)
        d = District.where(:name=>params[:DN3], :state_id=>stateIdNow)[0]
        dbb=DistrictBoundedBy.where(:district_id=>d.id)[0]
        if !dbb.nil?
          dbb.destroy
        end
        m1=MapPoint.create(:latitude=>params[:TLLat3], :longitude=>params[:TLLong3])
        m2=MapPoint.create(:latitude=>params[:BRLat3], :longitude=>params[:BRLong3])
        DistrictBoundedBy.create(:district_id=>d.id, :top_left_corner_id=>m1.id, :bottom_right_corner_id=>m2.id)
        session[:districtName]=params[:DN3]
      else
        flash[:error] = "district didn't already exist !Get its location info Add a new district"
        @districtName = District.where(:state_id=>stateIdNow).map{|x| x.name};
        render 'writer_district.html.erb'
      end
    end
    @TS= TouristSpot.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name)
    @EP=EntryPoint.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name)
    @LTS = LocalTransportStand.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name);
    @H = Hotel.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name);
  end


  def writer_done
    keys = params.keys
    tskeys = keys.select{|x| x[0]=='T'}
    tsdkeys = tskeys.select{|x| x[x.length-1]=='D'}
    tskeys = tskeys - tsdkeys
    epkeys = keys.select{|x| x[0]=='E'}
    epdkeys = keys.select{|x| x[x.length-1]=='D'}
    epkeys = epkeys - epdkeys
    hkeys = keys.select{|x| x[0]=='H'}
    hdkeys = keys.select{|x| x[x.length-1]=='D'}
    hkeys = hkeys - hdkeys
    ltskeys = keys.select{|x| x[0]=='L'}
    ltsdkeys = keys.select {|x| x[x.length-1]=='D' }
    ltskeys = ltskeys - ltsdkeys
    @user = User.find(params[:id])
    i = 0
    while i < tskeys.size do
      name = params[tskeys[i]]
      lat = params[tskeys[i+1]]
      long = params[tskeys[i+2]]
      desc = params[tskeys[i+3]]
      cat = params[tskeys[i+4]]
      if(TouristSpot.exists?(:name=>name, :category=>cat))
        t = TouristSpot.where(:name=>name, :category=>cat)[0]
        unless t.update_attributes(:latitude=>lat,:longitude=>long,:description=>desc)
          flash[:error]="Invalid attributes of TouristSpot #{name}"
          redirect_to "/users/#{@user.id}/writer_final", :DN2 => session[:districtName]
          return
        end
      else
        t = TouristSpot.new
        puts "fucked"
        puts cat
        puts "fucked"
        t.name=name
        t.category=cat
        t.latitude=lat
        t.longitude=long
        t.description=desc
        t.stateName = session[:stateName]
        t.districtName = session[:districtName]
        if !t.valid?
          puts t.name
          puts t.category
          puts t.latitude
          puts t.longitude
          puts t.description
          puts "NOT VALID"
          flash[:error]="Invalid attributes of TouristSpot #{name}"
          redirect_to "/users/#{@user.id}/writer_final", :DN2 => session[:districtName]
          return
        else
          t.save
        end
      end
      i+=5
    end
    i = 0
    while i < tsdkeys.size do
      name=params[tsdkeys[i]]
      cat=params[tsdkeys[i+1]]
      if(TouristSpot.exists?(:name=>name, :category=>cat))
        t = TouristSpot.where(:name=>name, :category=>cat)[0]
        t.destroy
      else
        flash[:error]="TouristSpot does not exist"
        redirect_to "/users/#{@user.id}/writer_final", :DN2 => session[:districtName]
        return
      end
      i+=2
    end

    # Now lets modify hotels
    i = 0
    while i < hkeys.size do
      name = params[hkeys[i]]
      lat = params[hkeys[i+1]]
      long = params[hkeys[i+2]]
      desc = params[hkeys[i+3]]
      if(Hotel.exists?(:name=>name, :stateName=>session[:stateName], :districtName=>session[:districtName]))
        t = Hotel.where(:name=>name, :stateName=>session[:stateName], :districtName=>session[:districtName])[0]
        unless t.update_attributes(:latitude=>lat,:longitude=>long,:description=>desc)
          flash[:error]="Invalid attributes of TouristSpot #{name}"
          redirect_to "/users/#{@user.id}/writer_final", :DN2 => session[:districtName]
          return
        end
      else
        t = Hotel.new
        t.name=name
        t.latitude=lat
        t.longitude=long
        t.description=desc
        t.stateName = session[:stateName]
        t.districtName = session[:districtName]
        if !t.valid?
          flash[:error]="Invalid attributes of TouristSpot #{name}"
          redirect_to "/users/#{@user.id}/writer_final", :DN2 => session[:districtName]
          return
        else
          t.save
        end
      end
      i+=4
    end
    i = 0
    while i < hdkeys.size do
      name=params[hdkeys[i]]
      if(Hotel.exists?(:name=>name, :stateName=>session[:stateName], :districtName=>session[:districtName]))
        t = Hotel.where(:name=>name, :stateName=>session[:stateName], :districtName=>session[:districtName])[0]
        t.destroy
      else
        flash[:error]="Invalid attributes of TouristSpot #{name}"
        redirect_to "/users/#{@user.id}/writer_final", :DN2 => session[:districtName]
        return
      end
      i+=1
    end

    # Now lets modify EntryPoint
    i = 0
    while i < epkeys.size do
      name = params[epkeys[i]]
      lat = params[epkeys[i+1]]
      long = params[epkeys[i+2]]
      type = params[epkeys[i+3]]
      puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
      puts type
      puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
      if(EntryPoint.exists?(:name=>name, :entryType=>type, :stateName=>session[:stateName], :districtName=>session[:districtName]))
        t = EntryPoint.where(:name=>name, :entryType=>type, :stateName=>session[:stateName], :districtName=>session[:districtName])
        unless t.update_attributes(:latitude=>lat,:longitude=>long)
          flash[:error]="Invalid attributes of TouristSpot #{name}"
          redirect_to "/users/#{@user.id}/writer_final", :DN2 => session[:districtName]
          return
        end
      else
        t = EntryPoint.new
        t.name=name
        t.latitude=lat
        t.longitude=long
        t.entryType=type
        t.stateName = session[:stateName]
        t.districtName = session[:districtName]
        if !t.valid?
          flash[:error]="Invalid attributes of TouristSpot #{name}"
          redirect_to "/users/#{@user.id}/writer_final", :DN2 => session[:districtName]
          return
        else
          t.save
        end
      end
      i+=4
    end
    i = 0
    while i < epdkeys.size do
      name=params[epdkeys[i]]
      type=params[epdkeys[i+1]]
      if(EntryPoint.exists?(:name=>name, :entryType=>type))
        t = EntryPoint.where(:name=>name, :entryType=>type)[0]
        t.destroy
      else
        flash[:error]="Hotel does not exist"
        redirect_to "/users/#{@user.id}/writer_final", :DN2 => session[:districtName]
        return
      end
      i+=2
    end

    # Now lets modify LocalTransportStands
    i = 0
    while i < ltskeys.size do
      name = params[ltskeys[i]]
      lat = params[ltskeys[i+1]]
      long = params[ltskeys[i+2]]
      type = params[ltskeys[i+3]]
      if(LocalTransportStand.exists?(:name=>name, :localTransport=>type, :stateName=>session[:stateName], :districtName=>session[:districtName]))
        t = LocalTransportStand.where(:name=>name, :localTransport=>type, :stateName=>session[:stateName], :districtName=>session[:districtName])[0]
        unless t.update_attributes(:latitude=>lat,:longitude=>long)
          flash[:error]="Invalid attributes of TouristSpot #{name}"
          redirect_to "/users/#{@user.id}/writer_final", :DN2 => session[:districtName]
          return
        end
      else
        t = LocalTransportStand.new
        t.name=name
        t.latitude=lat
        t.longitude=long
        t.localTransport=type
        t.stateName = session[:stateName]
        t.districtName = session[:districtName]
        if !t.valid?
          flash[:error]="Invalid attributes of TouristSpot #{name}"
          redirect_to "/users/#{@user.id}/writer_final", :DN2 => session[:districtName]
          return
        else
          t.save
        end
      end
      i+=4
    end

    i = 0
    while i < ltsdkeys.size do
      name=params[tsdkeys[i]]
      type=params[tsdkeys[i+1]]
      if(LocalTransportStand.exists?(:name=>name, :localTransport=>type, :stateName=>session[:stateName], :districtName=>session[:districtName]))
        t = LocalTransportStand.where(:name=>name, :localTransport=>type, :stateName=>session[:stateName], :districtName=>session[:districtName])[0]
        t.destroy
      else
        flash[:error]="Invalid attributes of TouristSpot #{name}"
        redirect_to "/users/#{@user.id}/writer_final", :DN2 => session[:districtName]
        return
      end
      i+=2
    end
    flash[:notice]="DONE!"
    redirect_to "/users/#{params[:id]}"
  end
end