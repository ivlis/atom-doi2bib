Doi2bib = require '../lib/doi2bib'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.
describe "doi2bib", ->

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('doi2bib')

  it 'it loads', ->
    expect(atom.packages.isPackageActive('doi2bib')).toBe true
