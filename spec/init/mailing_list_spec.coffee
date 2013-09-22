describe 'BH.Init.MailingList', ->
  beforeEach ->
    @callback = jasmine.createSpy('callback')

    syncStore =
      get: jasmine.createSpy('get')
      remove: jasmine.createSpy('remove')
      set: jasmine.createSpy('set')

    @mailingList = new BH.Init.MailingList
      syncStore: syncStore

  describe '#prompt', ->
    describe 'when the mailing list prompt has not been seen', ->
      describe 'when the timer is greater than 1', ->
        beforeEach ->
          @mailingList.syncStore.get.andCallFake (keys, callback) ->
            callback(mailingListPromptTimer: 3)

        it 'sets the prompt timer as one less in the sync store', ->
          @mailingList.prompt(@callback)
          expect(@mailingList.syncStore.set).toHaveBeenCalledWith
            mailingListPromptTimer: 2

        it 'does not call the passed callback', ->
          @mailingList.prompt(@callback)
          expect(@callback).not.toHaveBeenCalled()

      describe 'when the timer is equal to 1', ->
        beforeEach ->
          @mailingList.syncStore.get.andCallFake (keys, callback) ->
            callback(mailingListPromptTimer: 1)

        it 'calls the passed callback', ->
          @mailingList.prompt(@callback)
          expect(@callback).toHaveBeenCalled()

        it 'removes the prompt timer from the sync store', ->
          @mailingList.prompt(@callback)
          expect(@mailingList.syncStore.remove).toHaveBeenCalledWith 'mailingListPromptTimer'

        it 'sets the prompt as being seen in the sync store', ->
          @mailingList.prompt(@callback)
          expect(@mailingList.syncStore.set).toHaveBeenCalledWith
            mailingListPromptSeen: true

    describe 'when the mailing list prompt has been seen', ->
      it 'does not call the passed callback', ->
        @mailingList.prompt(@callback)
        expect(@callback).not.toHaveBeenCalled()
