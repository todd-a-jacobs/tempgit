#!/usr/bin/env ruby

module TempGit
  require_relative 'tempgit/tempgit'

  if __FILE__ == $0
    repository = TempGit::GitDir.new
    4.times do
      repository.add_new_file
      repository.commit_with_sequence_number
    end
    puts repository.git('log')
  end
end
