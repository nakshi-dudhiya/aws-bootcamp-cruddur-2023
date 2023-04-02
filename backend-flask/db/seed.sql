INSERT INTO public.users (display_name, email, handle, cognito_user_id)
VALUES
  ('Nakshi Dudhiya', 'nakshidudhiya@gmail.com', 'ncodes', 'MOCK'),
  ('Andrew Brown', 'dudhiyanakshi@gmail.com','andrewbrown' ,'MOCK');
  /*('Londo Mallori', 'lmollari@centari,com', 'londo', 'MOCK');*/

INSERT INTO public.activities (user_uuid, message, expires_at)
VALUES
  (
    (SELECT uuid from public.users WHERE users.handle = 'andrewbrown' LIMIT 1),
    'This was imported as seed data!',
    current_timestamp + interval '10 day'
  )