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
    @districtName = District.all.map{|x| "#{x.name}, #{x.state.name}"}
    # @districtName = District.all.map{|x| {:value=>"#{x.name}",:label =>"#{x.name}, #{x.state.name}"}}
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
        marker.json({ :id => touristSpot.id,:type => 'parent',:type2 => 'touristSpot'})
      end

      @json2 = Hotel.all.to_gmaps4rails do |hotel, marker|
        # marker.infowindow render_to_string(:partial => "/hotels/infowindow", :locals => { :hotel => hotel})
        marker.picture({:picture => "../../assets/hotel.png",
          :width => 32,
          :height => 32})
        marker.title "#{hotel.name}"
        marker.json({ :id => hotel.id, :type => 'parent',:type2 => 'hotel'})
      end

      @json3 = EntryPoint.all.to_gmaps4rails do |entryPoint, marker|
        # marker.infowindow render_to_string(:partial => "/entryPoints/infowindow", :locals => { :entryPoint => entryPoint})
        mode = "airplane"
        if entryPoint.entryType==1
          mode="railway"
        end
        marker.picture({:picture => "../../assets/" + mode + ".png",
          :width => 32,
          :height => 32})
        marker.title "#{entryPoint.name}"
        marker.json({ :id => entryPoint.id, :type => 'parent',:type2 => 'entryPoint'})

      end

      @trips = User.find(params[:id].to_i).trips.map{|x| {:name => x.name , :date => x.start_date}}

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @touristSpots }
      end
      # render 'show.html.erb'
    end
  end

  def select_city

    @districtName = District.all.map{|x| "#{x.name}, #{x.state.name}"}
    # puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaa"
    # puts params.keys
    # puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaa"
    @user = User.find(params[:id])
    @touristSpots = TouristSpot.all
    @hotels = Hotel.all
    @entryPoints = EntryPoint.all
    array = params[:session][:city].gsub(/\s+/, "").split(",")
    state = array[1]
    district = array[0]

    @tripTagData = params[:session][:service].split(',')

    @json1 = TouristSpot.where(:stateName => state , :districtName => district).to_gmaps4rails do |touristSpot, marker|
      # marker.infowindow render_to_string(:partial => "/touristSpots/infowindow", :locals => { :touristSpot => touristSpot})
      marker.picture({:picture => "../../assets/marker.png",
        :width => 32,
        :height => 32})
      marker.title "#{touristSpot.name}"
      marker.json({ :id => touristSpot.id,:type => 'parent',:type2 => 'touristSpot'})
    end

    @json2 = Hotel.where(:stateName => state , :districtName => district).to_gmaps4rails do |hotel, marker|
      # marker.infowindow render_to_string(:partial => "/hotels/infowindow", :locals => { :hotel => hotel})
      marker.picture({:picture => "../../assets/hotel.png",
        :width => 32,
        :height => 32})
      marker.title "#{hotel.name}"
      marker.json({ :id => hotel.id, :type => 'parent',:type2 => 'hotel'})
    end

    @json3 = EntryPoint.where(:stateName => state , :districtName => district).to_gmaps4rails do |entryPoint, marker|
      # marker.infowindow render_to_string(:partial => "/entryPoints/infowindow", :locals => { :entryPoint => entryPoint})
      mode = "airplane"
      if entryPoint.entryType==1
        mode="railway"
      end
      marker.picture({:picture => "../../assets/" + mode + ".png",
        :width => 32,
        :height => 32})
      marker.title "#{entryPoint.name}"
      marker.json({ :id => entryPoint.id, :type => 'parent',:type2 => 'entryPoint'})

    end
    @trips = User.find(params[:id].to_i).trips.map{|x| {:name => x.name , :date => x.start_date}}
    puts params.keys
    render 'show.html.erb'
  end

  def add_review
    puts params.keys
    r = Review.new
    r.user_id=params[:id].to_i
    r.tourist_spot_id=params[:tid].to_i
    r.review = params[:review].to_s
    r.rating = params[:rating].to_f
    if r.valid?
      flash[:notice] = "review added along with rating"
      r.save
    else
      flash[:error] = "rating must be between 1 and 10"
    end
    respond_to do |format|
      format.html
      format.json { render :nothing => true }
    end
  end

  def add_trip
    puts params.keys
    t = Trip.new
    t.user_id = params[:id].to_i
    t.name = params[:tripName].to_s
    t.start_date = params[:tripDate].strip()+" 00:00:00"
    if t.valid?
      flash[:notice] = "trip added"
      t.save
    else
      flash[:error] = "invalid attributes, only one trip can start on one day"
      respond_to do |format|
        format.html
        format.json { render :nothing => true }
      end
      return
    end
    params[:currentTrip].values.each do |trip|
      od = OneDay.new
      od.user_id = params[:id].to_i
      od.day_number = trip[1].to_i
      od.tourist_spot_id = trip[0].to_i
      od.start_date = t.start_date
      if od.valid?
        od.save
      else
        flash[:error] = "Some attribute is not valid in some OneDay"
        break
      end
    end
    @data = User.find(params[:id].to_i).trips.map{|x| {:name => x.name, :date =>x.start_date}}
    respond_to do |format|
      format.html
      format.json { render :json => @data }
    end
  end

  def show_closer_to
    tid = params[:tid]
    ltsCloserToDist = Hash[TouristSpot.find(tid).closer_tos.all.map{ |x| ["#{x.local_transport_stand.name}","#{x.distance}"]}]
    @ltsCloserTo =  LocalTransportStand.where("id in (select local_transport_stand_id from closer_tos where tourist_spot_id=#{tid})").all.to_gmaps4rails do |localTransportStand, marker|
      marker.picture({:picture => "../../assets/" +localTransportStand.localTransport + ".png",
        :width => 32,
        :height => 32})
      marker.title "#{localTransportStand.name}"
      marker.json({ :id => localTransportStand.id, :type => 'child',:distance => ltsCloserToDist[localTransportStand.name]})
    end
    respond_to do |format|
      format.html
      format.json { render :json => @ltsCloserTo }
    end    
  end

  
  def show_buddies
    tid=params[:tid]
    ltsCloserToDist = Hash[TouristSpot.find(tid).buddies.all.map{ |x| ["#{x.friend.name}","#{x.distance}"]}].merge(Hash[TouristSpot.find(tid).inverse_buddies.all.map{ |x| ["#{x.tourist_spot.name}","#{x.distance}"]}])

    # tsCloserToDist = Hash[TouristSpot.find(tid).buddies.all.map{ |x| ["#{x.tourist_spot.name}","#{x.distance}"]}]
    # @tsCloserTo = TouristSpot.where("id in (select friend_id from buddies where tourist_spot_id=#{tid})").all.to_gmaps4rails do |touristSpot,marker|
    closerToTouristspots =  TouristSpot.find(tid).buddies.map{|x| x.friend} + TouristSpot.find(tid).inverse_buddies.map{|x| x.tourist_spot}
    @tsCloserTo = closerToTouristspots.each.to_gmaps4rails do |touristSpot,marker|

      marker.picture({
        :picture => "../../assets/" + touristSpot.category+".png",
        :width => 32,
        :height => 32
        })
      marker.title "#{touristSpot.name}"
      marker.json({:id => touristSpot.id, :type => 'child', :distance => ltsCloserToDist[touristSpot.name]})
    end
    respond_to do |format|
      format.html
      format.json{ render :json => @tsCloserTo}
    end
  end

  def show_nearby_hotels
    tid=params[:tid]
    hotelCloserToDist = Hash[TouristSpot.find(tid).in_proximity_ofs.all.map{ |x| ["#{x.hotel.name}","#{x.distance}"]}]
    @hotelCloserTo = Hotel.where("id in (select hotel_id from in_proximity_ofs where tourist_spot_id=#{tid})").all.to_gmaps4rails do |hotel,marker|
      marker.picture({
        :picture => "../../assets/hotel.png",
        :width => 32,
        :height => 32
        })
      marker.title "#{hotel.name}"
      marker.json({:id => hotel.id, :type => 'child',:distance => hotelCloserToDist[hotel.name]})
    end
    respond_to do |format|
      format.html
      format.json{ render :json => @hotelCloserTo}
    end
  end

  # nearby_ts_hotel
  def nearby_ts_hotel
    tid=params[:tid]
    tsCloserToDist = Hash[Hotel.find(tid).in_proximity_ofs.all.map{ |x| ["#{x.tourist_spot.name}","#{x.distance}"]}]
    @tsCloserTo = TouristSpot.where("id in (select tourist_spot_id from in_proximity_ofs where hotel_id=#{tid})").all.to_gmaps4rails do |ts,marker|
      marker.picture({
        :picture => "../../assets"+ ts.category+".png",
        :width => 32,
        :height => 32
        })
      marker.title "#{ts.name}"
      marker.json({:id => ts.id, :type => 'child',:distance => tsCloserToDist[ts.name]})
    end
    respond_to do |format|
      format.html
      format.json{ render :json => @tsCloserTo}
    end
  end

  # nearby_lts_hotel
  def nearby_lts_hotel
    tid=params[:tid]
    ltsCloserToDist = Hash[Hotel.find(tid).near_bies.all.map{ |x| ["#{x.local_transport_stand.name}","#{x.distance}"]}]
    @ltsCloserTo = LocalTransportStand.where("id in (select local_transport_stand_id from near_bies where hotel_id=#{tid})").all.to_gmaps4rails do |lts,marker|
      marker.picture({
        :picture => "../../assets"+ lts.localTransport+".png",
        :width => 32,
        :height => 32
        })
      marker.title "#{lts.name}"
      marker.json({:id => lts.id, :type => 'child',:distance => ltsCloserToDist[lts.name]})
    end
    respond_to do |format|
      format.html
      format.json{ render :json => @ltsCloserTo}
    end
  end

  # nearby_hotel_ep
  def nearby_hotel_ep
    tid=params[:tid]
    hotelCloserToDist = Hash[EntryPoint.find(tid).closest_hotels.all.map{ |x| ["#{x.hotel.name}","#{x.distance}"]}]
    @hotelCloserTo = Hotel.where("id in (select hotel_id from closest_hotels where entry_point_id=#{tid})").all.to_gmaps4rails do |hotel,marker|
      marker.picture({
        :picture => "../../assets/hotel.png",
        :width => 32,
        :height => 32
        })
      marker.title "#{hotel.name}"
      marker.json({:id => hotel.id, :type => 'child',:distance => hotelCloserToDist[hotel.name]})
    end
    respond_to do |format|
      format.html
      format.json{ render :json => @hotelCloserTo}
    end
  end


  def get_tourist_spot_info
    tid = params[:tid]
    @tsInfo = TouristSpot.find(tid)
    reviewAndUserInfo = []
    @tsInfo.reviews.each do |r|
      reviewAndUser = {}
      reviewAndUser[:username] = r.user.username
      reviewAndUser[:review] = r.review
      reviewAndUser[:rating] = r.rating
      reviewAndUserInfo.append(reviewAndUser)
      # puts reviewAndUserInfo
    end
    @Info = { :tsInfo => @tsInfo, :reviewAndUserInfo => reviewAndUserInfo}
    respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @Info }
      end
    end

    def get_hotel_info
      tid = params[:tid]
      @hInfo = Hotel.find(tid)
      @hDesc= @hInfo.description
      @HInfo = { :hInfo => @hInfo, :hDesc => @hDesc}
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @HInfo }
      end
    end

    def get_entry_point_info
      tid = params[:tid]
      @epInfo = EntryPoint.find(tid)
    # @epDesc= @epInfo.description
    # @EInfo = { :hInfo => @epInfo, :hDesc => @epDesc}
    respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @epInfo }
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
    state = State.where(:name=>session[:stateName])[0]
    stateIdNow = state.id
    topLeft = state.top_left_corner
    bottomRight = state.bottom_right_corner
    if params[:DN1] # ADD NEW DISTRICT
      if District.exists?(:name=>params[:DN1], :state_id=>stateIdNow)
        flash[:notice] = "District already exists"
      else
        if(params[:TLLat1]-topLeft.latitude)*(params[:BRLat1]-bottomRight.latitude) <= 0 and
          (params[:TLLong1]-topLeft.longitude)*(params[:BRLong1]- bottomRight.longitude) <= 0
          flash[:error] = "District must lie inside the parent state, check the latitude and longitude"
          redirect_to "/users/#{@user.id}/writer_district"
        else
          d=District.create(:name=>params[:DN1], :state_id=>stateIdNow)
          m1=MapPoint.create(:latitude=>params[:TLLat1], :longitude=>params[:TLLong1])
          m2=MapPoint.create(:latitude=>params[:BRLat1], :longitude=>params[:BRLong1])
          DistrictBoundedBy.create(:district_id=>d.id, :top_left_corner_id=>m1.id, :bottom_right_corner_id=>m2.id)
          session[:districtName]=params[:DN1]
        end
      end
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
        if(params[:TLLat1]-topLeft.latitude)*(params[:BRLat1]-bottomRight.latitude) > 0 and
          (params[:TLLong1]-topLeft.longitude)*(params[:BRLong1]- bottomRight.longitude) > 0
          flash[:error] = "District must lie inside the parent state, check the latitude and longitude"
          redirect_to "/users/#{@user.id}/writer_district"
        else
          d=District.create(:name=>params[:DN1], :state_id=>stateIdNow)
          m1=MapPoint.create(:latitude=>params[:TLLat1], :longitude=>params[:TLLong1])
          m2=MapPoint.create(:latitude=>params[:BRLat1], :longitude=>params[:BRLong1])
          DistrictBoundedBy.create(:district_id=>d.id, :top_left_corner_id=>m1.id, :bottom_right_corner_id=>m2.id)
          session[:districtName]=params[:DN3]
        end
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
    puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    puts session[:stateName]+","+session[:districtName]
    puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    puts @TS
    puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    puts @EP
    puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    puts @LTS
    puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    puts @H
    puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
  end


  def writer_done
    state = State.where(:name=>session[:stateName])[0]
    stateIdNow = state.id
    district = District.where(:name=>session[:districtName], :state_id=>stateIdNow)[0]
    topLeft = district.top_left_corner
    bottomRight = district.bottom_right_corner

    keys = params.keys
    tskeys = keys.select{|x| x[0]=='T'}
    tsdkeys = tskeys.select{|x| x[2]=='d'}
    tskeys = tskeys - tsdkeys
    epkeys = keys.select{|x| x[0]=='E'}
    epdkeys = epkeys.select{|x| x[2]=='d'}
    epkeys = epkeys - epdkeys
    hkeys = keys.select{|x| x[0]=='H'}
    hdkeys = hkeys.select{|x| x[1]=='d'}
    hkeys = hkeys - hdkeys
    ltskeys = keys.select{|x| x[0]=='L'}
    ltsdkeys = ltskeys.select {|x| x[3]=='d' }
    ltskeys = ltskeys - ltsdkeys
    @user = User.find(params[:id])
    puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    puts hkeys.size
    puts hdkeys.size
    puts keys
    puts "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    i = 0
    while i < tskeys.size do
      name = params[tskeys[i]]
      lat = params[tskeys[i+1]].to_f
      long = params[tskeys[i+2]].to_f
      desc = params[tskeys[i+3]]
      cat = params[tskeys[i+4]]
      if(TouristSpot.exists?(:name=>name, :category=>cat))
        t = TouristSpot.where(:name=>name, :category=>cat)[0]
        unless t.update_attributes(:latitude=>lat,:longitude=>long,:description=>desc)
          flash[:error]="Invalid attributes of TouristSpot 1 #{name}"
          redirect_to "/users/#{@user.id}/writer_final", :DN2 => session[:districtName]
          return
        end
      else
        if  (topLeft.latitude-lat)*(bottomRight.latitude-lat) <= 0 and
          (topLeft.longitude-long)*(bottomRight.longitude-long) <= 0
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
            flash[:error]="Invalid attributes of TouristSpot 2 #{name}"
            redirect_to "/users/#{@user.id}/writer_final", :DN2 => session[:districtName]
            return
          else
            t.save
          end
        else
          flash[:error]="TouristSpot 1 #{name} does not lie inside the district, check latitude and longitude"
          redirect_to "/users/#{@user.id}/writer_final", :DN2 => session[:districtName]
          return
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
      lat = params[hkeys[i+1]].to_f
      long = params[hkeys[i+2]].to_f
      desc = params[hkeys[i+3]]
      if(Hotel.exists?(:name=>name, :stateName=>session[:stateName], :districtName=>session[:districtName]))
        t = Hotel.where(:name=>name, :stateName=>session[:stateName], :districtName=>session[:districtName])[0]
        unless t.update_attributes(:latitude=>lat,:longitude=>long,:description=>desc)
          flash[:error]="Invalid attributes of Hotel 1 #{name}"
          redirect_to "/users/#{@user.id}/writer_final", :DN2 => session[:districtName]
          return
        end
      else
        if  (topLeft.latitude-lat)*(bottomRight.latitude-lat) <= 0 and
          (topLeft.longitude-long)*(bottomRight.longitude-long) <= 0
          t = Hotel.new
          t.name=name
          t.latitude=lat
          t.longitude=long
          t.description=desc
          t.stateName = session[:stateName]
          t.districtName = session[:districtName]
          if !t.valid?
            flash[:error]="Invalid attributes of Hotel 2 #{name}"
            redirect_to "/users/#{@user.id}/writer_final", :DN2 => session[:districtName]
            return
          else
            t.save
          end
        else
          flash[:error]="Hotel 1 #{name} does not lie inside the district, check latitude and longitude"
          redirect_to "/users/#{@user.id}/writer_final", :DN2 => session[:districtName]
          return
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
        flash[:error]=" Hotel doesn't exist #{name}"
        redirect_to "/users/#{@user.id}/writer_final", :DN2 => session[:districtName]
        return
      end
      i+=1
    end

    # Now lets modify EntryPoint
    i = 0
    while i < epkeys.size do
      name = params[epkeys[i]]
      lat = params[epkeys[i+1]].to_f
      long = params[epkeys[i+2]].to_f
      type = params[epkeys[i+3]]
      if(EntryPoint.exists?(:name=>name, :entryType=>type, :stateName=>session[:stateName], :districtName=>session[:districtName]))
        t = EntryPoint.where(:name=>name, :entryType=>type, :stateName=>session[:stateName], :districtName=>session[:districtName])
        unless t.update_attributes(:latitude=>lat,:longitude=>long)
          flash[:error]="Invalid attributes of EntryPoint 1 #{name}"
          redirect_to "/users/#{@user.id}/writer_final", :DN2 => session[:districtName]
          return
        end
      else
        if  (topLeft.latitude-lat)*(bottomRight.latitude-lat) <= 0 and
          (topLeft.longitude-long)*(bottomRight.longitude-long) <= 0
          t = EntryPoint.new
          t.name=name
          t.latitude=lat
          t.longitude=long
          t.entryType=type
          t.stateName = session[:stateName]
          t.districtName = session[:districtName]
          if !t.valid?
            flash[:error]="Invalid attributes of EntryPoint 2 #{name}"
            redirect_to "/users/#{@user.id}/writer_final", :DN2 => session[:districtName]
            return
          else
            t.save
          end
        else
          flash[:error]="EntryPoint 1 #{name} does not lie inside the district, check latitude and longitude"
          redirect_to "/users/#{@user.id}/writer_final", :DN2 => session[:districtName]
          return
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
        flash[:error]="EntryPoint does not exist"
        redirect_to "/users/#{@user.id}/writer_final", :DN2 => session[:districtName]
        return
      end
      i+=2
    end

    # Now lets modify LocalTransportStands
    i = 0
    while i < ltskeys.size do
      name = params[ltskeys[i]]
      lat = params[ltskeys[i+1]].to_f
      long = params[ltskeys[i+2]].to_f
      type = params[ltskeys[i+3]]
      if(LocalTransportStand.exists?(:name=>name, :localTransport=>type, :stateName=>session[:stateName], :districtName=>session[:districtName]))
        t = LocalTransportStand.where(:name=>name, :localTransport=>type, :stateName=>session[:stateName], :districtName=>session[:districtName])[0]
        unless t.update_attributes(:latitude=>lat,:longitude=>long)
          flash[:error]="Invalid attributes of LTS1 #{name}"
          redirect_to "/users/#{@user.id}/writer_final", :DN2 => session[:districtName]
          return
        end
      else
        if  (topLeft.latitude-lat)*(bottomRight.latitude-lat) <= 0 and
          (topLeft.longitude-long)*(bottomRight.longitude-long) <= 0
          t = LocalTransportStand.new
          t.name=name
          t.latitude=lat
          t.longitude=long
          t.localTransport=type
          t.stateName = session[:stateName]
          t.districtName = session[:districtName]
          if !t.valid?
            flash[:error]="Invalid attributes of LTS2 #{name}"
            redirect_to "/users/#{@user.id}/writer_final", :DN2 => session[:districtName]
            return
          else
            t.save
          end
        else
          flash[:error]="LocalTransportStand 1 #{name} does not lie inside the district, check latitude and longitude"
          redirect_to "/users/#{@user.id}/writer_final", :DN2 => session[:districtName]
          return
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
        flash[:error]="LTS Does not exist #{name}"
        redirect_to "/users/#{@user.id}/writer_final", :DN2 => session[:districtName]
        return
      end
      i+=2
    end
    flash[:notice]="DONE!"
    redirect_to "/users/#{params[:id]}"
  end
end