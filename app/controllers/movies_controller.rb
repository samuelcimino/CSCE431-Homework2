class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.get_ratings	
	ratings_checked = ['G','PG','PG-13','R']
	
	if session[:movies]
	  @movies = session[:movies]
	else
	  @movies = Movie.all
	end
	
	if params["ratings"]
	  ratings_checked = []
	  @movies = Movie.none
	  keys = params["ratings"].keys
	
	  for k in keys
		@movies += Movie.where("rating = ?", k)
		ratings_checked.push(k)
      end
	  session[:ratings_checked] = ratings_checked
	else
	  @movies = Movie.none
	  ratings_checked = session[:ratings_checked]
	  for k in ratings_checked
	    @movies += Movie.where("rating = ?", k)
	  end
	end

    if params["title"]
	  begin
	    @movies = @movies.order("title")
	    session["title"] = true
	    session["release"] = false
	  rescue
	    @movies = @movies.sort_by do |item|
		  item[:title]
		end
		session["title"] = true
	    session["release"] = false
	  end
	  
	elsif params["release"]
	  begin
	    @movies = @movies.order("release_date")
	    session["title"] = false
	    session["release"] = true
	  rescue
	    @movies = @movies.sort_by do |item|
		  item[:release_date]
		end
		session["title"] = false
	    session["release"] = true
	  end
	  
	elsif session["title"]
	  begin
	    @movies = @movies.order("title")
	    session["title"] = true
	    session["release"] = false
	  rescue
	    @movies = @movies.sort_by do |item|
		  item[:title]
		end
		session["title"] = true
	    session["release"] = false
	  end
	  
	elsif session["release"]
	  begin
	    @movies = @movies.order("release_date")
	    session["title"] = false
	    session["release"] = true
	  rescue
	    @movies = @movies.sort_by do |item|
		  item[:release_date]
		end
		session["title"] = false
	    session["release"] = true
	  end
	end
    @ratings_checked = ratings_checked
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  def sort_title
    @movies = Movie.all.order("title")
  end

end
