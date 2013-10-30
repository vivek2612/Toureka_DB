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
      @json1 = TouristSpot.all.to_gmaps4rails do |touristSpot, marker|
        marker.infowindow render_to_string(:partial => "/touristSpots/infowindow", :locals => { :touristSpot => touristSpot})
        marker.picture({:picture => "../../assets/marker.png",
                        :width => 32,
                        :height => 32})
        marker.title "#{touristSpot.name}"
        #   marker.json({ :population => character.address})
      end

      @json2 = Hotel.all.to_gmaps4rails do |hotel, marker|
        marker.infowindow render_to_string(:partial => "/hotels/infowindow", :locals => { :hotel => hotel})
        # marker.picture({:picture => "../../assets/marker2.png",
        #                 :width => 32,
        #                 :height => 32})
        marker.title "#{hotel.name}"
        #   marker.json({ :population => character.address})
      end

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @touristSpots }
      end
      # render 'show.html.erb'
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
        DistrictBoundedBy.create(:state_id=>stateIdNow, :district_id=>d.id, :top_left_corner_id=>m1.id, :bottom_right_corner_id=>m2.id)
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
        dbb=DistrictBoundedBy.find(:district_id=>d.id, :state_id=>stateIdNow)
        dbb.top_left_corner.delete
        dbb.bottom_right_corner.delete
        dbb.delete
        m1=MapPoint.create(:latitude=>params[:TLLat3], :longitude=>params[:TLLong3])
        m2=MapPoint.create(:latitude=>params[:BRLat3], :longitude=>params[:BRLong3])
        DistrictBoundedBy.create(:district_id=>d.id, :state_id=>stateIdNow, :top_left_corner_id=>m1.id, :bottom_right_corner_id=>m2.id)
        session[:districtName]=@params[:DN3]
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
    tsdkeys = tskeys.select{|x| x[2]=='D'}
    tskeys = tskeys - tsdkeys
    epkeys = keys.select{|x| x[0]=='E'}
    epdkeys = keys.select{|x| x[2]=='D'}
    epkeys = epkeys - epdkeys
    hkeys = keys.select{|x| x[0]=='H'}
    hdkeys = keys.select{|x| x[1]=='D'}
    hkeys = hkeys - hdkeys
    ltskeys = keys.select{|x| x[0]=='L'}
    ltsDkeys = keys.select {|x| x[3]=='D' }
    ltskeys = ltskeys - ltsdkeys
    i = 0
    while i < tskeys.size
      name = params[tskeys[i]]
      lat = params[tskeys[i+1]]
      long = params[tskeys[i+2]]
      desc = params[tskeys[i+3]]
      cat = params[tskeys[i+4]]
      if(TouristSpot.exists?(:name=>name, :category=>cat))
        t = TouristSpot.where(:name=>name, :category=>cat)[0]
        unless t.update_attributes(:latitude=>lat,:longitude=>long,:description=>desc)
          @TS= TouristSpot.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name)
          @EP=EntryPoint.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name)
          @LTS = LocalTransportStand.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name);
          @H = Hotel.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name);
          @user = User.find(params[:id])
          flash[:error]="Invalid attributes of TouristSpot #{@TS.name}"
          render 'writer_final.html.erb'
        end
      else
        t = TouristSpot.new
        t.name=name
        t.category=cat
        t.latitude=lat
        t.longitude=long
        t.description=desc
        if t.save?
          @TS= TouristSpot.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name)
          @EP=EntryPoint.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name)
          @LTS = LocalTransportStand.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name);
          @H = Hotel.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name);
          @user = User.find(params[:id])
          flash[:error]="Invalid attributes of TouristSpot #{@TS.name}"
          render 'writer_final.html.erb'
        else
          t.save
        end
      end
      i+=5
    end
    i = 0
    while i < tsdkeys.size
      name=params[tsdkeys[i]]
      cat=params[tsdkeys[i+1]]
      if(TouristSpot.exists?(:name=>name, :category=>cat))
        t = TouristSpot.where(:name=>name, :category=>cat)[0]
        t.destroy
      else
        flash[:error]="TouristSpot does not exist"
        @TS= TouristSpot.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name)
        @EP=EntryPoint.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name)
        @LTS = LocalTransportStand.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name);
        @H = Hotel.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name);
        @user = User.find(params[:id])
        render 'writer_final.html.erb'
      end
      i+=2
    end

    # Now lets modify hotels
    i = 0
    while i < hkeys.size
      name = params[hkeys[i]]
      lat = params[hkeys[i+1]]
      long = params[hkeys[i+2]]
      desc = params[hkeys[i+3]]
      if(Hotel.exists?(:name=>name, :stateName=>session[:stateName], :districtName=>session[:districtName]))
        t = Hotel.where(:name=>name, :stateName=>session[:stateName], :districtName=>session[:districtName])[0]
        unless t.update_attributes(:latitude=>lat,:longitude=>long,:description=>desc)
          @TS= TouristSpot.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name)
          @EP=EntryPoint.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name)
          @LTS = LocalTransportStand.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name);
          @H = Hotel.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name);
          @user = User.find(params[:id])
          flash[:error]="Invalid attributes of TouristSpot #{@TS.name}"
          render 'writer_final.html.erb'
        end
      else
        t = Hotel.new
        t.name=name
        t.latitude=lat
        t.longitude=long
        t.description=desc
        if t.save?
          @TS= TouristSpot.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name)
          @EP=EntryPoint.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name)
          @LTS = LocalTransportStand.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name);
          @H = Hotel.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name);
          @user = User.find(params[:id])
          flash[:error]="Invalid attributes of TouristSpot #{@TS.name}"
          render 'writer_final.html.erb'
        else
          t.save
        end
      end
      i+=4
    end
    i = 0
    while i < hdkeys.size
      name=params[hdkeys[i]]
      if(Hotel.exists?(:name=>name, :stateName=>session[:stateName], :districtName=>session[:districtName]))
        t = Hotel.where(:name=>name, :stateName=>session[:stateName], :districtName=>session[:districtName])[0]
        t.destroy
      else
        flash[:error]="Hotel does not exist"
        @TS= TouristSpot.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name)
        @EP=EntryPoint.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name)
        @LTS = LocalTransportStand.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name);
        @H = Hotel.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name);
        @user = User.find(params[:id])
        render 'writer_final.html.erb'
      end
      i+=1
    end

    # Now lets modify EntryPoint
    i = 0
    while i < epkeys.size
      name = params[epkeys[i]]
      lat = params[epkeys[i+1]]
      long = params[epkeys[i+2]]
      type = params[epkeys[i+3]]
      if(EntryPoint.exists?(:name=>name, :entryType=>type, :stateName=>session[:stateName], :districtName=>session[:districtName]))
        t = EntryPoint.where(:name=>name, :entryType=>type, :stateName=>session[:stateName], :districtName=>session[:districtName])
        unless t.update_attributes(:latitude=>lat,:longitude=>long)
          @TS= TouristSpot.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name)
          @EP=EntryPoint.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name)
          @LTS = LocalTransportStand.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name);
          @H = Hotel.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name);
          @user = User.find(params[:id])
          flash[:error]="Invalid attributes of TouristSpot #{@TS.name}"
          render 'writer_final.html.erb'
        end
      else
        t = EntryPoint.new
        t.name=name
        t.latitude=lat
        t.longitude=long
        t.entryType=type
        if t.save?
          @TS= TouristSpot.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name)
          @EP=EntryPoint.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name)
          @LTS = LocalTransportStand.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name);
          @H = Hotel.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name);
          @user = User.find(params[:id])
          flash[:error]="Invalid attributes of Hotel #{@TS.name}"
          render 'writer_final.html.erb'
        else
          t.save
        end
      end
      i+=4
    end
    i = 0
    while i < epdkeys.size
      name=params[epdkeys[i]]
      type=params[epdkeys[i+1]]
      if(EntryPoint.exists?(:name=>name, :entryType=>type))
        t = EntryPoint.where(:name=>name, :entryType=>type)[0]
        t.destroy
      else
        flash[:error]="Hotel does not exist"
        @TS= TouristSpot.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name)
        @EP=EntryPoint.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name)
        @LTS = LocalTransportStand.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name);
        @H = Hotel.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name);
        @user = User.find(params[:id])
        render 'writer_final.html.erb'
      end
      i+=2
    end

    # Now lets modify LocalTransportStands
    i = 0
    while i < ltskeys.size
      name = params[ltskeys[i]]
      lat = params[ltskeys[i+1]]
      long = params[ltskeys[i+2]]
      type = params[ltskeys[i+3]]
      if(LocalTransportStand.exists?(:name=>name, :transportType=>type, :stateName=>session[:stateName], :districtName=>session[:districtName]))
        t = LocalTransportStand.where(:name=>name, :transportType=>type, :stateName=>session[:stateName], :districtName=>session[:districtName])[0]
        unless t.update_attributes(:latitude=>lat,:longitude=>long)
          @TS= TouristSpot.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name)
          @EP=EntryPoint.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name)
          @LTS = LocalTransportStand.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name);
          @H = Hotel.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name);
          @user = User.find(params[:id])
          flash[:error]="Invalid attributes of LocalTransportStand #{@TS.name}"
          render 'writer_final.html.erb'
        end
      else
        t = LocalTransportStand.new
        t.name=name
        t.latitude=lat
        t.longitude=long
        t.transportType=type
        if t.save?
          @TS= TouristSpot.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name)
          @EP=EntryPoint.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name)
          @LTS = LocalTransportStand.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name);
          @H = Hotel.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name);
          @user = User.find(params[:id])
          flash[:error]="Invalid attributes of TouristSpot #{@TS.name}"
          render 'writer_final.html.erb'
        else
          t.save
        end
      end
      i+=4
    end
    i = 0
    while i < ltsdkeys.size
      name=params[tsdkeys[i]]
      type=params[tsdkeys[i+1]]
      if(LocalTransportStand.exists?(:name=>name, :transportType=>type, :stateName=>session[:stateName], :districtName=>session[:districtName]))
        t = LocalTransportStand.where(:name=>name, :transportType=>type, :stateName=>session[:stateName], :districtName=>session[:districtName])[0]
        t.destroy
      else
        flash[:error]="LocalTransportStand does not exist"
        @TS= TouristSpot.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name)
        @EP=EntryPoint.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name)
        @LTS = LocalTransportStand.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name);
        @H = Hotel.where(:districtName=>session[:districtName], :stateName=>session[:stateName]).pluck(:name);
        @user = User.find(params[:id])
        render 'writer_final.html.erb'
      end
      i+=2
    end

    flash[:notice]="DONE!"
    redirect_to "/users/#{params[:id]}"
  end

end