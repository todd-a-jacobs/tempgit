require 'spec_helper'

# Helper to remove the current and parent directories from the
# <tt>Dir.entries</tt> list, as well as any hidden files such as the
# .git directory under the working tree.
def remove_dot_dirs directory_entries
  directory_entries.delete_if { |e| e =~ /^[.]+/ }
end

describe TempGit::GitDir do
  let(:repository) {TempGit::GitDir.new}
  let(:log_format) {'log --pretty=oneline'}

  describe '#new' do
    it 'creates a working directory' do
      Dir.exists?(repository.work_tree).should be_true
    end

    it 'creates a file in the working tree' do
      remove_dot_dirs(Dir.entries(repository.work_tree)).
        should have(1).file
    end

    it 'creates a .git directory' do
      Dir.exists?(repository.git_dir).should be_true
    end

    it 'populates the .git directory' do
      Dir.entries(repository.git_dir).should have_at_least(8).items
    end

    it 'should have one initial commit' do
      repository.git(log_format).scan(/\n/).should have(1).line
    end

  end # describe '#new'

  describe '#add_new_file' do
    before  { repository.add_new_file }

    specify do
      remove_dot_dirs(Dir.entries(repository.work_tree)).
        should have(2).files
    end
  end

  describe '#commit_with_sequence_number' do
    before {
      4.times do
        repository.add_new_file
        repository.commit_with_sequence_number
      end
      @log = repository.git(log_format).split "\n"
    }

    specify { @log.should have(5).commits }
    specify { @log.first.should include 'Commit number 5' }
  end

  describe '#git' do
    it 'should run an arbitrary git command' do
      repository.git('--version').should match /^git version/
    end
  end

end # describe TempGit::GitDir
