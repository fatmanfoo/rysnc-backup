#!/usr/bin/env ruby

require 'fileutils'

# FileManager.rb
# vr1.2 14 Nov 2016
# Class for doing file related stuff
# 29 Aug 2015 add method clean
# 30 Aug moved source and destination form initialize to filesync
# 14 Nov 2016 added file_move method
# 14 Nov 2016 added file_rm method

class FileManager
  # create the source, destination and log paths
  def initialize
	@log = "/Users/serveradmin/Documents/Logs/"
	@startTime = Time.now
  end


  # format time: pass in time and will output 0 serial, 1 format
  def timefmt(time, option)
	stime = time.to_i
	ftime = time.strftime("%Y-%m-%d %H:%M:%S")
	output = [stime, ftime] 
	return output[option]
  end

  # uses unix sync to copy files from source to destination
  # output is written to a log file
  def filesync(src_in, dst_in)
  	source = "/Volumes/LaCie/" + src_in + "/"
	destination = "/Volumes/" + dst_in + "/" + src_in + "/"
	ts = self.timefmt(@startTime, 0)
	tf = self.timefmt(@startTime, 1)
	lfile = File.new(@log +"LogFile" + ts.to_s + ".txt", "w") #=> open file 
	lfile.puts "File created " + tf.to_s  #=> write header
	lfile.puts `rsync -arv #{source} #{destination}`
	tf = self.timefmt(Time.now, 1) #=> get end time
	lfile.puts "End of file " + tf.to_s  #=> write footer
	lfile.close
  end
  
  # removes log files older than a week
  def clean
	# define variables
	aweek = (60 * 60 * 24 * 7)
	aweekold = @startTime - aweek

	Dir.foreach(@log) do |item|
		next if item == '.' or item == '..'
		file = File.new(@log + item)
		if file.ctime < aweekold
			File.unlink(@log + item)
		end
	end
  end

  def test
	test = self.timefmt(@startTime, 1)
	puts test
  end

  # displays variable values
  def show
	puts @source
	puts @destination
	puts @startTime
	puts @log
  end

  # moves all files from source to destination
  def file_move(src, dst)
    @source = src
    @destination = dst
    Dir.chdir(@source)
    Dir.glob("*.*") do |filename|
      FileUtils.mv filename, @destination
    end
  end

  # removes all files in source directory
  def file_rm(src)
    @source = src
    Dir.chdir(@source)
    FileUtils.rm Dir.glob("*.*")
  end
end

