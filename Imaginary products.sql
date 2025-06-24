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
