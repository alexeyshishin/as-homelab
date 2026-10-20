local cfg = import '../lib/config.libsonnet';
local g = import 'grafonnet-latest/main.libsonnet';

local stat = g.panel.stat;
local timeSeries = g.panel.timeSeries;
local gauge = g.panel.gauge;

local prom(expr) = g.query.prometheus.new(cfg.datasourceType, expr);

g.dashboard.new('Main')
+ g.dashboard.withUid('main')
+ g.dashboard.withTags(cfg.tags)
+ g.dashboard.withRefresh(cfg.refresh)
+ g.dashboard.time.withFrom(cfg.timeFrom)
+ g.dashboard.withPanels([
  g.panel.row.new('Node health')
  + g.panel.row.gridPos.withY(0),

  timeSeries.new('Server Uptime')
  + timeSeries.queryOptions.withDatasource(cfg.datasourceType, cfg.datasourceType)
  + timeSeries.queryOptions.withTargets([
    prom('node_time_seconds - node_boot_time_seconds'),
  ])
  + timeSeries.standardOptions.withUnit('s')
  + timeSeries.gridPos.withX(0)
  + timeSeries.gridPos.withY(1)
  + timeSeries.gridPos.withW(12)
  + timeSeries.gridPos.withH(5),

  timeSeries.new('CPU usage')
  + timeSeries.queryOptions.withDatasource(cfg.datasourceType, cfg.datasourceType)
  + timeSeries.queryOptions.withTargets([
    prom('100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)'),
  ])
  + timeSeries.standardOptions.withUnit('percent')
  + timeSeries.gridPos.withX(12)
  + timeSeries.gridPos.withY(1)
  + timeSeries.gridPos.withW(12)
  + timeSeries.gridPos.withH(5)
  + timeSeries.fieldConfig.defaults.custom.withFillOpacity(50),

  gauge.new('Memory usage')
  + gauge.queryOptions.withDatasource(cfg.datasourceType, cfg.datasourceType)
  + gauge.queryOptions.withTargets([
    prom('100 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100)'),
  ])
  + gauge.standardOptions.withUnit('percent')
  + gauge.gridPos.withX(0)
  + gauge.gridPos.withY(6)
  + gauge.gridPos.withW(12)
  + gauge.gridPos.withH(5),
])
