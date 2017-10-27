var bh = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: '/games/autocomplete/%QUERY', wildcard: '%QUERY'
});
bh.initialize();

$('#game-typeahead').typeahead(null, {
    displayKey: 'name',
    source: bh.ttAdapter()
});
