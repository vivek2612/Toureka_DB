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
      @json = TouristSpot.all.to_gmaps4rails #do |touristSpot, marker|
      #   # marker.infowindow render_to_string(:partial => "/touristSpots/infowindow", :locals => { :character => character})
      #   marker.picture({:picture => "assets/marker.png",
      #                   :width => 32,
      #                   :height => 32})
      #   marker.title "#{touristSpot.name}"
      #   #   marker.json({ :population => character.address})
      # end
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
      @stateName = State.find(:name=>params[:SN1]).name
      session[:stateName]=@stateName
      @districtName = District.where(:name=>params[:SN1]).map{|x| x.name};
    elsif params[:SN2] # ADD TO EXISTING STATE
      unless State.exists?(:name=>params[:SN2])
        flash[:error] = "State didn't already exist ! Add a new state"
        @stateName = State.pluck(:name);
        render 'writer_show.html.erb'
      end
      @stateName = State.find(:name=>params[:SN2]).name
      session[:stateName]=@stateName
      @districtName = District.where(:name=>params[:SN2]).map{|x| x.name};
    elsif params[:SN3] # MODIFY EXISTING AND ADD TO IT
      if State.exists?(:name=>params[:SN3])
        s = State.find(:name=>params[:SN3])
        sbb=StateBoundedBy.find(:state_id=>State.find(:name=>params[:SN3]).id)
        sbb.top_left_corner.delete
        sbb.bottom_right_corner.delete
        sbb.delete
        m1=MapPoint.create(:latitude=>params[:TLLat3], :longitude=>params[:TLLong3])
        m2=MapPoint.create(:latitude=>params[:BRLat3], :longitude=>params[:BRLong3])
        StateBoundedBy.create(:state_id=>s.id, :top_left_corner_id=>m1.id, :bottom_right_corner_id=>m2.id)
        @stateName = State.find(:name=>params[:SN3]).name
        session[:stateName]=@stateName
        @districtName = District.where(:name=>params[:SN3]).map{|x| x.name};
      else
        flash[:error]="State doesn't exist"
        @stateName = State.pluck(:name);
        render 'writer_show.html.erb'
      end
    end
  end

  def writer_final
    
    puts session[:stateName]
    @TSName = TouristSpot.pluck(:name);
    @EPName = EntryPoint.pluck(:name);
    @LTSName = LocalTransportStand.pluck(:name);
    @HName = Hotel.pluck(:name);
    @user = User.find(params[:id])
  end

  def writer_done
    puts params[:awesome]
    puts "SASSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS"
    redirect_to "/users/#{params[:id]}"
  end

end
