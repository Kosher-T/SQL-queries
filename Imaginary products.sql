-- New exercise. Hardest one yet
-- Table: enom_gilpane
CREATE TABLE enom_gilpane (
    part_id TEXT,
    rpm REAL,
    watt INTEGER,
    size INTEGER
);

-- Populate enom_gilpane
INSERT INTO enom_gilpane (part_id, rpm, watt, size) VALUES
('A', 4269.372, 95, 7),
('B', 8914.598, 174, 4),
('C', 7853.7, 36, 6),
('D', 3984.036, 146, 16),
('A', 8728.528, 90, 17),
('B', 1711.437, 192, 12),
('C', 6773.778, 46, 1),
('D', 9083.355, 198, 13),
('A', 2556.883, 190, 19),
('B', 3191.102, 161, 11),
('C', 6398.457, 126, 18),
('D', 8614.086, 38, 20);

-- Table: castle_loctus
CREATE TABLE castle_loctus (
    part_id TEXT,
    rpm REAL,
    watt INTEGER,
    size INTEGER
);

-- Populate castle_loctus
INSERT INTO castle_loctus (part_id, rpm, watt, size) VALUES
('A', 2973.576, 150, 1),
('C', 6886.279, 42, 7),
('D', 2329.252, 191, 16),
('E', 4690.612, 74, 15),
('A', 3415.696, 125, 3),
('C', 5503.339, 138, 8),
('D', 2047.412, 93, 19),
('E', 1887.138, 71, 17),
('A', 3075.848, 39, 2),
('C', 4399.997, 133, 4),
('D', 3979.093, 154, 18),
('E', 4811.204, 31, 13);

-- Table: honpan_bilopsa
CREATE TABLE honpan_bilopsa (
    part_id TEXT,
    rpm REAL,
    watt INTEGER,
    size INTEGER
);

-- Populate honpan_bilopsa
INSERT INTO honpan_bilopsa (part_id, rpm, watt, size) VALUES
('B', 7095.499, 85, 22),
('D', 5020.034, 58, 11),
('E', 8782.956, 87, 9),
('F', 5885.662, 62, 7),
('B', 7151.229, 81, 15),
('D', 5111.166, 45, 6),
('E', 5429.338, 54, 5),
('F', 4936.521, 90, 16),
('B', 6588.933, 95, 21),
('D', 5355.704, 27, 19),
('E', 5625.185, 91, 25),
('F', 8738.879, 76, 8);

-- Table: yurnol_qoltam
CREATE TABLE yurnol_qoltam (
    part_id TEXT,
    rpm REAL,
    watt INTEGER,
    size INTEGER
);

-- Populate yurnol_qoltam
INSERT INTO yurnol_qoltam (part_id, rpm, watt, size) VALUES
('F', 4126.755, 74, 20),
('C', 3602.962, 102, 9),
('A', 4341.742, 112, 7),
('B', 3322.368, 144, 25),
('F', 4313.828, 88, 27),
('C', 3157.77, 143, 21),
('A', 4510.035, 121, 22),
('B', 4897.276, 54, 29),
('F', 4755.144, 61, 30),
('C', 3147.466, 81, 10),
('A', 3806.276, 150, 17),
('B', 4089.562, 70, 14);


WITH
  -- Step 1: Calculate the quality for each part in the 'enom_gilpane' table.
  -- The quality formula is (rpm * (watt + avg_watt_for_table)) / size.
  enom_gilpane_quality AS (
    SELECT
      part_id,
      (
        rpm * (
          watt + (
            SELECT
              AVG(watt)
            FROM
              enom_gilpane
          )
        )
      ) / size AS quality
    FROM
      enom_gilpane
  ),
  -- Filter 'enom_gilpane' parts to keep only those with a quality score
  -- greater than the average quality for this specific product table.
  enom_gilpane_final AS (
    SELECT
      part_id,
      quality
    FROM
      enom_gilpane_quality
    WHERE
      quality > (
        SELECT
          AVG(quality)
        FROM
          enom_gilpane_quality
      )
  ),
  -- Step 2: Repeat the quality calculation for the 'castle_loctus' table.
  castle_loctus_quality AS (
    SELECT
      part_id,
      (
        rpm * (
          watt + (
            SELECT
              AVG(watt)
            FROM
              castle_loctus
          )
        )
      ) / size AS quality
    FROM
      castle_loctus
  ),
  -- Filter 'castle_loctus' parts.
  castle_loctus_final AS (
    SELECT
      part_id,
      quality
    FROM
      castle_loctus_quality
    WHERE
      quality > (
        SELECT
          AVG(quality)
        FROM
          castle_loctus_quality
      )
  ),
  -- Step 3: Repeat the quality calculation for the 'honpan_bilopsa' table.
  honpan_bilopsa_quality AS (
    SELECT
      part_id,
      (
        rpm * (
          watt + (
            SELECT
              AVG(watt)
            FROM
              honpan_bilopsa
          )
        )
      ) / size AS quality
    FROM
      honpan_bilopsa
  ),
  -- Filter 'honpan_bilopsa' parts.
  honpan_bilopsa_final AS (
    SELECT
      part_id,
      quality
    FROM
      honpan_bilopsa_quality
    WHERE
      quality > (
        SELECT
          AVG(quality)
        FROM
          honpan_bilopsa_quality
      )
  ),
  -- Step 4: Repeat the quality calculation for the 'yurnol_qoltam' table.
  yurnol_qoltam_quality AS (
    SELECT
      part_id,
      (
        rpm * (
          watt + (
            SELECT
              AVG(watt)
            FROM
              yurnol_qoltam
          )
        )
      ) / size AS quality
    FROM
      yurnol_qoltam
  ),
  -- Filter 'yurnol_qoltam' parts.
  yurnol_qoltam_final AS (
    SELECT
      part_id,
      quality
    FROM
      yurnol_qoltam_quality
    WHERE
      quality > (
        SELECT
          AVG(quality)
        FROM
          yurnol_qoltam_quality
      )
  ),
  -- Step 5: Combine all the filtered parts from the four tables into a single result set.
  -- UNION ALL is used because we want to include all resulting rows from each table.
  all_valid_parts AS (
    SELECT
      *
    FROM
      enom_gilpane_final
    UNION ALL
    SELECT
      *
    FROM
      castle_loctus_final
    UNION ALL
    SELECT
      *
    FROM
      honpan_bilopsa_final
    UNION ALL
    SELECT
      *
    FROM
      yurnol_qoltam_final
  )
-- Step 6: Calculate the final average quality for each 'part_id' from the combined data.
-- Group the results by part_id and order them by the final calculated quality in descending order.
SELECT
  part_id,
  AVG(quality) AS quality
FROM
  all_valid_parts
GROUP BY
  part_id
ORDER BY
  quality DESC;
