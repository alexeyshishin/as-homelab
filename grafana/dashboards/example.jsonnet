local config = import '../lib/config.libsonnet';
local g = import 'grafonnet-latest/main.libsonnet';

g.dashboard.new('Example')
+ g.dashboard.withUid('example')
+ g.dashboard.withTags(config.tags)
+ g.dashboard.withRefresh(config.refresh)
+ g.dashboard.time.withFrom(config.timeFrom)
+ g.dashboard.withPanels([])
