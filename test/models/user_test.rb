require 'test_helper'

describe User do

  it "cannot be created without a name" do
    proc { User.create!(password: '1234567890') }.must_raise ActiveRecord::RecordInvalid
  end

  it "cannot be created without a password" do
    proc { User.create!(name: 'Perpendiklos') }.must_raise ActiveRecord::RecordInvalid
  end

  it "cannot have the name of another user" do
    existing_name = users(:some_user).name
    proc { User.create!(name: existing_name) }.must_raise ActiveRecord::RecordInvalid
  end

  it "cannot delete only admin while other users exist" do
    proc { users(:first_admin).destroy! }.must_raise ActiveRecord::RecordNotDestroyed
  end

  it "can be deleted as long last admin deleted last" do
    User.where.not(id: users(:first_admin)).each { |u| u.destroy! }
    users(:first_admin).destroy!
  end

  it "is always created as admin when no other users exist" do
    User.delete_all
    User.count.must_equal 0, "no users must exist"
    u = User.create!(name: 'firstUser', password: '1234567890')
    assert u.is_admin?
  end

  it "is not auto-created as admin when other users exist" do
    u = User.create!(name: 'firstUser', password: '1234567890')
    refute u.is_admin?
  end


end
