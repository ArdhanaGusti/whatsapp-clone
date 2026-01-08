CREATE DEFINER=`root`@`localhost`
PROCEDURE `chatapp`.`lastMessages`(IN userId INT)
BEGIN
    WITH cte_last_message_id AS (
        SELECT 
            MAX(id) AS id,
            CONCAT(
                LEAST(m.sender_id, m.receiver_id), 
                ',', 
                GREATEST(m.sender_id, m.receiver_id)
            ) AS grp
        FROM `chatapp`.messages m
        WHERE m.sender_id = userId 
           OR m.receiver_id = userId
        GROUP BY grp
    )
    SELECT 
        m.id,
        m.message,
        o.username AS opposite_name,
        m.created_at,
        m.updated_at,
        m.deleted_at,
        CASE 
            WHEN m.sender_id = userId THEN TRUE 
            ELSE FALSE 
        END AS is_sender
    FROM `chatapp`.messages m
    INNER JOIN cte_last_message_id ce
        ON m.id = ce.id
    LEFT JOIN `chatapp`.users o
        ON CASE 
            WHEN m.sender_id = userId 
            THEN m.receiver_id 
            ELSE m.sender_id 
        END = o.id;
END;
