--
-- Copyright © 2016-2024 The Thingsboard Authors
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--

-- QUEUE STATS UPDATE START

CREATE TABLE IF NOT EXISTS queue_stats (
    id uuid NOT NULL CONSTRAINT queue_stats_pkey PRIMARY KEY,
    created_time bigint NOT NULL,
    tenant_id uuid NOT NULL,
    queue_name varchar(255) NOT NULL,
    service_id varchar(255) NOT NULL,
    CONSTRAINT queue_stats_name_unq_key UNIQUE (tenant_id, queue_name, service_id)
);

INSERT INTO queue_stats
    SELECT id, created_time, tenant_id, substring(name FROM 1 FOR position('_' IN name) - 1) AS queue_name,
           substring(name FROM position('_' IN name) + 1) AS service_id
    FROM asset
    WHERE type = 'TbServiceQueue' and name LIKE '%\_%';

DELETE FROM asset WHERE type='TbServiceQueue';
DELETE FROM asset_profile WHERE name ='TbServiceQueue';

-- QUEUE STATS UPDATE END
