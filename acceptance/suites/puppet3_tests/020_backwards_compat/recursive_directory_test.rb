require 'puppetserver/acceptance/compat_utils'

test_name 'recursive directory file resource'

studio = "/tmp/simmons-studio-#{Process.pid}"
agent = nonmaster_agents().first

teardown do
  cleanup(studio)
end

step "Apply simmons::recursive_directory to agent(s)" do
  apply_simmons_class(agent, master, studio, 'simmons::recursive_directory')
end

step "Validate recursive-directory" do
  directory_exists = on(agent, "test -d #{studio}/recursive-directory").exit_code
  assert_equal(0, directory_exists)

  file1_contents = on(agent, "cat #{studio}/recursive-directory/file1").stdout.chomp
  assert_equal('recursive file 1', file1_contents)

  file2_contents = on(agent, "cat #{studio}/recursive-directory/file2").stdout.chomp
  assert_equal('recursive file 2', file2_contents)

  subdir_exists = on(agent, "test -d #{studio}/recursive-directory/subdir").exit_code
  assert_equal(0, subdir_exists)

  subfile_contents = on(agent, "cat #{studio}/recursive-directory/subdir/subfile").stdout.chomp
  assert_equal('recursive subfile contents', subfile_contents)
end
