use utf8;
package Schema::Result::CurrencyExchangeRate;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::CurrencyExchangeRate

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<currency_exchange_rates>

=cut

__PACKAGE__->table("currency_exchange_rates");

=head1 ACCESSORS

=head2 date_create

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: 'CURRENT_TIMESTAMP'
  is_nullable: 0

=head2 currency_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 val

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "date_create",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    default_value => "CURRENT_TIMESTAMP",
    is_nullable => 0,
  },
  "currency_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "val",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
);

=head1 RELATIONS

=head2 currency

Type: belongs_to

Related object: L<Schema::Result::Currency>

=cut

__PACKAGE__->belongs_to(
  "currency",
  "Schema::Result::Currency",
  { currency_id => "currency_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2016-05-25 12:57:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:jMgd01pqtENCCjXxT4rQtw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
