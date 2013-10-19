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



end
