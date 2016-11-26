use utf8;
package Schema::Result::Feature2group;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::Feature2group

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<feature2group>

=cut

__PACKAGE__->table("feature2group");

=head1 ACCESSORS

=head2 feature_group_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 feature_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "feature_group_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "feature_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</feature_group_id>

=back

=cut

__PACKAGE__->set_primary_key("feature_group_id");

=head1 RELATIONS

=head2 feature

Type: belongs_to

Related object: L<Schema::Result::Feature>

=cut

__PACKAGE__->belongs_to(
  "feature",
  "Schema::Result::Feature",
  { feature_id => "feature_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "NO ACTION" },
);

=head2 feature_group

Type: belongs_to

Related object: L<Schema::Result::FeatureGroup>

=cut

__PACKAGE__->belongs_to(
  "feature_group",
  "Schema::Result::FeatureGroup",
  { feature_group_id => "feature_group_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2016-05-25 12:57:13
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:e8EzuEhNAyZRw1akepkPBw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
