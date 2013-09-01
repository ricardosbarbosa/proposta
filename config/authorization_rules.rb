authorization do
  role :proposal do
    has_permission_on [:proposals], :to => [:index, :show, :new, :create, :edit, :update, :destroy, :comment]
  end

  role :guest do
    has_permission_on [:proposals], :to => [:show, :comment]
  end

end
