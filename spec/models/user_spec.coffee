describe 'BH.Models.User', ->
  beforeEach ->
    @user = new BH.Models.User()
    spyOn(@user, 'save')
    spyOn(@user, 'trigger')

  describe '#login', ->
    beforeEach ->
      @data =
        authId: '123123'
        firstName: 'Bill'
        lastName: 'Smith'

    it 'sets the passed data on the model', ->
      @user.login @data
      expect(@user.toJSON()).toEqual
        authId: '123123'
        firstName: 'Bill'
        lastName: 'Smith'

    it 'saves the data', ->
      @user.login @data
      expect(@user.save).toHaveBeenCalled()

    it 'triggers a login event', ->
      @user.login @data
      expect(@user.trigger).toHaveBeenCalledWith('login')

  describe '#logout', ->
    beforeEach ->
      spyOn(@user, 'clear')

    it 'silently clears the model data', ->
      @user.logout()
      expect(@user.clear).toHaveBeenCalledWith(silent: true)

    it 'saves the data', ->
      @user.logout()
      expect(@user.save).toHaveBeenCalled()

    it 'triggers a logout event', ->
      @user.logout()
      expect(@user.trigger).toHaveBeenCalledWith('logout')
