const fs = require('fs');
const { parse } = require('csv-parse/sync');

const input = fs.readFileSync('/data/data.csv', 'utf8');
const records = parse(input, { columns: true, skip_empty_lines: true });

if (records.length === 0) {
  console.error('CSV пустой');
  process.exit(1);
}

const columns = Object.keys(records[0]);
const numericStats = {};
const categoricalStats = {};

for (const col of columns) {
  const rawValues = records.map(r => r[col]);
  const numericValues = rawValues.map(v => parseFloat(v)).filter(v => !isNaN(v));

  if (numericValues.length === rawValues.length) {
    numericStats[col] = {
      count: numericValues.length,
      min: Math.min(...numericValues).toFixed(2),
      max: Math.max(...numericValues).toFixed(2),
      mean: (numericValues.reduce((a, b) => a + b, 0) / numericValues.length).toFixed(2),
    };
  } else {
    const freq = {};
    for (const v of rawValues) {
      freq[v] = (freq[v] || 0) + 1;
    }
    categoricalStats[col] = freq;
  }
}

const numericRows = Object.entries(numericStats).map(([col, s]) =>
  `<tr><td>${col}</td><td>${s.count}</td><td>${s.min}</td><td>${s.max}</td><td>${s.mean}</td></tr>`
).join('');

const categoricalSections = Object.entries(categoricalStats).map(([col, freq]) => {
  const rows = Object.entries(freq)
    .sort((a, b) => b[1] - a[1])
    .map(([val, cnt]) => `<tr><td>${val}</td><td>${cnt}</td></tr>`)
    .join('');
  return `
    <h2>${col}</h2>
    <table>
      <thead><tr><th>Значение</th><th>Кол-во</th></tr></thead>
      <tbody>${rows}</tbody>
    </table>`;
}).join('');

const html = `<!DOCTYPE html>
<html lang="ru">
<head>
  <meta charset="UTF-8">
  <title>Отчёт по данным</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
    h1 { color: #333; }
    h2 { color: #555; margin-top: 30px; }
    table { border-collapse: collapse; width: 100%; max-width: 800px; background: white; }
    th, td { border: 1px solid #ccc; padding: 8px 12px; text-align: left; }
    th { background-color: #4a90e2; color: white; }
    tr:nth-child(even) { background-color: #f9f9f9; }
    .summary { background: white; padding: 16px; border-radius: 6px; margin-bottom: 20px; display: inline-block; }
  </style>
</head>
<body>
  <h1>📊 Аналитический отчёт</h1>
  <div class="summary">Всего строк: <strong>${records.length}</strong></div>

  <h2>Числовые колонки</h2>
  ${numericRows.length > 0 ? `
  <table>
    <thead><tr><th>Колонка</th><th>Кол-во</th><th>Min</th><th>Max</th><th>Среднее</th></tr></thead>
    <tbody>${numericRows}</tbody>
  </table>` : '<p>Нет числовых колонок</p>'}

  ${categoricalSections}
</body>
</html>`;

fs.writeFileSync('/data/report.html', html);
console.log('Отчёт сохранён в /data/report.html');