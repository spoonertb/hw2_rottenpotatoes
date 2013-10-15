class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    @sort = params[:sort] || session[:sort]
    @ratings = params[:ratings] || session[:ratings]


    if params[:sort].nil? && params[:ratings].nil? &&
      (!session[:sort].nil? || !session[:ratings].nil?)
      redirect_to :sort => @sort, :ratings => @ratings and return
    end
    
    if @ratings.nil?
      @ratings = {"G"=>1,"PG"=>1,"PG-13"=>1,"R"=>1}
    end

    if !@sort.nil?
      @movies = Movie.order("#{@sort} ASC").find_all_by_rating(@ratings.keys)
    else
      @movies = Movie.find_all_by_rating(@ratings.keys)
    end

    session[:ratings] = @ratings
    session[:sort] = @sort

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
