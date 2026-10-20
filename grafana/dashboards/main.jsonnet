local cfg = import '../lib/config.libsonnet';
local g = import 'grafonnet-latest/main.libsonnet';

local stat = g.panel.stat;

local prom(expr) = g.query.prometheus.new(cfg.datasourceType, expr);

g.dashboard.new('Main')
+ g.dashboard.withUid('main')
+ g.dashboard.withTags(cfg.tags)
+ g.dashboard.withRefresh(cfg.refresh)
+ g.dashboard.time.withFrom(cfg.timeFrom)
+ g.dashboard.withPanels([
  g.panel.row.new('Node health')
  + g.panel.row.gridPos.withY(0),

  stat.new('Server Uptime')
  + stat.queryOptions.withDatasource(cfg.datasourceType, cfg.datasourceType)
  + stat.queryOptions.withTargets([
    prom('node_time_seconds - node_boot_time_seconds'),
  ])
  + stat.standardOptions.withUnit('s')
  + stat.gridPos.withX(0)
  + stat.gridPos.withY(1)
  + stat.gridPos.withW(12)
  + stat.gridPos.withH(5),

  stat.new('CPU load')
  + stat.queryOptions.withDatasource(cfg.datasourceType, cfg.datasourceType)
  + stat.queryOptions.withTargets([
    prom('100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)'),
  ])
  + stat.standardOptions.withUnit('percent')
  + stat.gridPos.withX(12)
  + stat.gridPos.withY(1)
  + stat.gridPos.withW(12)
  + stat.gridPos.withH(5),
])
