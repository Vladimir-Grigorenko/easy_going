use utf8;
package Schema::Result::Currency;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::Currency

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<currency>

=cut

__PACKAGE__->table("currency");

=head1 ACCESSORS

=head2 currency_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=head2 name_en

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=head2 default

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "currency_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 45 },
  "name_en",
  { data_type => "varchar", is_nullable => 0, size => 45 },
  "default",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</currency_id>

=back

=cut

__PACKAGE__->set_primary_key("currency_id");

=head1 RELATIONS

=head2 currency_exchange_rates

Type: has_many

Related object: L<Schema::Result::CurrencyExchangeRate>

=cut

__PACKAGE__->has_many(
  "currency_exchange_rates",
  "Schema::Result::CurrencyExchangeRate",
  { "foreign.currency_id" => "self.currency_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 product_prices

Type: has_many

Related object: L<Schema::Result::ProductPrice>

=cut

__PACKAGE__->has_many(
  "product_prices",
  "Schema::Result::ProductPrice",
  { "foreign.currency_id" => "self.currency_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2016-05-25 12:57:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:hCZh0VA8jXwmnaaALviJ8g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
