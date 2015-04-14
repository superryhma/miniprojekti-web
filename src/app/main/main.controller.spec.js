'use strict';

describe('controllers', function(){
  var scope;

  beforeEach(module('web'));

  beforeEach(inject(function($rootScope) {
    scope = $rootScope.$new();
  }));
});
