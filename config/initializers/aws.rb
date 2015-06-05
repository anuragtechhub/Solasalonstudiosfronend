AWS.config(
  :access_key_id => 'AKIAJAKSXVOSIU7IYOTA',
  :secret_access_key => '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'
)

S3_BUCKET =  AWS::S3.new.buckets['solasalonstudiosblogandnewsassets']