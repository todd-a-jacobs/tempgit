#!/usr/bin/env ruby

module TempGit
  require 'tempfile'
  require 'tmpdir'
  require 'fileutils'

  # == Create a temporary Git directory for testing git-related tools.
  #
  # === Usage Example
  #   require 'tempgit'
  #
  #   repo = TempGit::GitDir.new
  #   puts repo.git('log')
  #
  #   repo.add_new_file
  #   puts repo.git('status')
  #
  #   repo.commit_with_sequence_number
  #   puts repo.git('log')
  #
  class GitDir
    # Do not delete the temporary directory at exit.
    attr_accessor :nosweep

    # Path to repository's working tree.
    attr_reader :work_tree

    # Path to .git repository.
    attr_reader :git_dir

    def initialize nosweep=false
      @seq_num = 0
      @work_tree = Dir.mktmpdir
      @git_dir = File.join(@work_tree, '.git')
      @nosweep = ENV['NOSWEEP'] || nosweep

      cleanup_at_exit @work_tree
      init_temp_repo
      add_new_file
      commit_with_sequence_number
    end

    def init_temp_repo
      git 'init'
    end

    # Create unique, empty file in the temporary git repository and add
    # it to the index.
    def add_new_file
      file = File.basename(Tempfile.new 'empty-', @work_tree)
      git 'add', file
    end

    # Commit current index to repository with an incrementing counter in
    # the commit message. Useful for ensuring the number of commits is
    # the repository meets expectations.
    def commit_with_sequence_number
      git %q/commit -m 'Commit number %d'/ % @seq_num+=1
    end

    # Run arbitrary git commands in the correct directory context.
    #
    # [commands] String or array of arguments to git.
    def git *commands
      context = %q/--git-dir="%s" --work-tree="%s"/ %
                [@git_dir, @work_tree]
      `git #{context} #{[*commands].join(' ')}`
    end

    # Returns timestamp with nanosecond resolution. Useful for creating
    # sequential files or non-colliding file content.
    #
    # [return] seconds_since_epoch.nanoseconds
    def timestamp
      Time.now.strftime '%s.%N'
    end

    # Sweep temporary git repositories at interpreter exit unless
    # nosweep is true.
    def cleanup_at_exit dir
      at_exit do
        if @nosweep
          $stderr.puts "\nAbandoning directory: #{dir}"
          Kernel::exit false
        else
          $stderr.puts "Directory missing: #{dir}" unless Dir.exists? dir
          fail "Refusing to purge directory outside /tmp: #{dir}" if
            File.dirname(dir) !~ %r{^/tmp}
          FileUtils.rm_rf dir, :secure => true
        end
      end
    end

  end # class GitDir
end # module TempGit
