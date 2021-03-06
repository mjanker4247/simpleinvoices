<!doctype html>  
<html>  
<head>  
<meta charset="utf-8" /> 
<link rel="stylesheet" type="text/css" href="{$css|urlsafe}" media="all">
<title>{$preference.pref_inv_wording|htmlsafe} {$LANG.number_short}: {$invoice.index_id|htmlsafe}</title>
</head>

<div id="wrapper">
	<div id="header">
		<img id="logo" src="{$logo|urlsafe}">
		<h1 id="invoice_title">{$preference.pref_inv_heading|htmlsafe}</h1>
<!-- Summary -->
		<div id="invoice_summary">
			<h2>{$preference.pref_inv_wording|htmlsafe} {$LANG.summary}</h2>
			<ul>
				<li class="invoice_number"><span class="desc">{$preference.pref_inv_wording|htmlsafe} {$LANG.number_short} </span><span class="number">{$invoice.index_id}</span></li>
				<li class="date"><span class="desc">{$preference.pref_inv_wording|htmlsafe} {$LANG.date}: </span><span>{$invoice.date}</span></li>
<!-- Show the Invoice Custom Fields if valid -->
{if $invoice.custom_field1 != null}
				<li class="custom_field custom_field1"><span class="desc">{$customFieldLabels.invoice_cf1|htmlsafe}: </span><span class="number">{$invoice.custom_field1|htmlsafe}</span></li>
{/if}
{if $invoice.custom_field2 != null}
				<li class="custom_field custom_field2"><span class="desc">{$customFieldLabels.invoice_cf2|htmlsafe}: </span><span class="number">{$invoice.custom_field2|htmlsafe}</span></li>
{/if}
{if $invoice.custom_field3 != null}
				<li class="custom_field custom_field3"><span class="desc">{$customFieldLabels.invoice_cf3|htmlsafe}: </span><span class="number">{$invoice.custom_field3|htmlsafe}</span></li>
{/if}
{if $invoice.custom_field4 != null}
				<li class="custom_field custom_field4"><span class="desc">{$customFieldLabels.invoice_cf4|htmlsafe}: </span><span class="number">{$invoice.custom_field4|htmlsafe}</span></li>
{/if}
				<li class="total"><span class="desc">{$LANG.total}: </span><span class="number">{$preference.pref_currency_sign|htmlsafe}{$invoice.total|siLocal_number}</span></li>
				<li class="paid"><span class="desc">{$LANG.paid}: </span><span class="number">{$preference.pref_currency_sign|htmlsafe}{$invoice.paid|siLocal_number}</span></li>
				<li class="owing"><span class="desc">{$LANG.owing}: </span><span class="number">{$preference.pref_currency_sign|htmlsafe}{$invoice.owing|siLocal_number}</span></li>
			</ul>
		</div>
	</div>

	<div id="invoice_body">
<!-- Parties -->
		<div id="invoice_parties">
		<!-- Biller -->
			<div id="invoice_biller" class="party">
				<h2>{$LANG.biller}</h2>
				<div id="info_biller" class="vcard">
					<div class="info_mail">
						<div class="org"><h3>{$biller.name|htmlsafe}</h3></div>
						<div class="adr"><span class="desc">{$LANG.address}: </span>
							<span class="adr-block">
{if $biller.street_address != null}
								<div class="street-address">{$biller.street_address|htmlsafe}</div>
{/if}
{if $biller.street_address2 != null }
								<div class="street-address street-address2">{$biller.street_address2|htmlsafe}</div>
{/if}
{if $biller.city != null }
								<span class="locality">{$biller.city|htmlsafe}</span>, 
{/if}
{if $biller.state != null }
								<span class="region">{$biller.state|htmlsafe}</span>, 
{/if}
{if $biller.zip_code != null }
								<span class="postal-code">{$biller.zip_code|htmlsafe}</span> 
{/if}
{if $biller.country != null }
								<span class="country-name">{$biller.country|htmlsafe}</span>
{/if}
							</span>
						</div>
					</div>
					<div class="info_other">
{if $biller.phone != null }
						<div class="tel"><span class="desc">{$LANG.phone}: </span><span class="number">{$biller.phone|htmlsafe}</span></div>
{/if}
{if $biller.fax != null }
						<div class="fax"><span class="desc">{$LANG.fax}: </span><span class="number">{$biller.fax|htmlsafe}</span></div>
{/if}
{if $biller.mobile != null }
						<div class="mobile"><span class="desc">{$LANG.mobile}: </span><span class="number">{$biller.mobile|htmlsafe}</span></div>
{/if}
{if $biller.email != null }
						<div class="email"><span class="desc">{$LANG.email}: </span><span>{$biller.email|htmlsafe}</span></div>
{/if}
{if $biller.custom_field1 != null }
						<div class="custom_field custom_field1"><span class="desc">{$customFieldLabels.biller_cf1}: </span><span>{$biller.custom_field1|htmlsafe}</span></div>
{/if}
{if $biller.custom_field2 != null }
						<div class="custom_field custom_field2"><span class="desc">{$customFieldLabels.biller_cf2}: </span><span>{$biller.custom_field2|htmlsafe}</span></div>
{/if}
{if $biller.custom_field3 != null }
						<div class="custom_field custom_field3"><span class="desc">{$customFieldLabels.biller_cf3}: </span><span>{$biller.custom_field3|htmlsafe}</span></div>
{/if}
{if $biller.custom_field4 != null }
						<div class="custom_field custom_field4"><span class="desc">{$customFieldLabels.biller_cf4}: </span><span>{$biller.custom_field4|htmlsafe}</span></div>
{/if}
					</div>
				</div>
			</div>



		<!-- Customer -->
			<div id="invoice_customer" class="party">
				<h2>{$LANG.customer}</h2>
				<div id="info_customer" class="vcard">
					<div class="info_mail">
						<div class="org"><h3>{$customer.name|htmlsafe}</h3></div>
{if $customer.attention != null }
						<h4 class="n attn">{$LANG.attention_short}: {$customer.attention|htmlsafe}</h4>
{/if}
						<div class="adr"><span class="desc">{$LANG.address}: </span>
							<span class="adr-block">
{if $customer.street_address != null }
							<div class="street-address">{$customer.street_address|htmlsafe}</div>
{/if}
{if $customer.street_address2 != null}
							<div class="street-address street-address2">{$customer.street_address2|htmlsafe}</div>
{/if}
{if $customer.city != null }
							<span class="locality">{$customer.city|htmlsafe}</span>, 
{/if}
{if $customer.state != null }
							<span class="region">{$customer.state|htmlsafe}</span>, 
{/if}
{if $customer.zip_code != null }
							<span class="postal-code">{$customer.zip_code|htmlsafe}</span> 
{/if}
{if $customer.country != null }
							<span class="country-name">{$customer.country|htmlsafe}</span>
{/if}
							</span>
						</div>
					</div>
					<div class="info_other">
{if $customer.phone != null }
						<div class="tel"><span class="desc">{$LANG.phone}: </span><span class="number">{$customer.phone|htmlsafe}</span></div>
{/if}
{if $customer.fax != null }
						<div class="fax"><span class="desc">{$LANG.fax}: </span><span class="number">{$customer.fax|htmlsafe}</span></div>
{/if}
{if $customer.mobile != null }
						<div class="mobile"><span class="desc">{$LANG.mobile}: </span><span class="number">{$customer.mobile|htmlsafe}</span></div>
{/if}
{if $customer.email != null }
						<div class="email"><span class="desc">{$LANG.email}: </span><span>{$customer.email|htmlsafe}</span></div>
{/if}
{if $customer.custom_field1 != null }
						<div class="custom_field custom_field1"><span class="desc">{$customFieldLabels.customer_cf1}: </span><span>{$customer.custom_field1|htmlsafe}</span></div>
{/if}
{if $customer.custom_field2 != null }
						<div class="custom_field custom_field2"><span class="desc">{$customFieldLabels.customer_cf2}: </span><span>{$customer.custom_field2|htmlsafe}</span></div>
{/if}
{if $customer.custom_field3 != null }
						<div class="custom_field custom_field3"><span class="desc">{$customFieldLabels.customer_cf3}: </span><span>{$customer.custom_field3|htmlsafe}</span></div>
{/if}
{if $customer.custom_field4 != null }
						<div class="custom_field custom_field4"><span class="desc">{$customFieldLabels.customer_cf4}: </span><span>{$customer.custom_field4|htmlsafe}</span></div>
{/if}
					</div>
				</div>
			</div>
		</div>



<!-- Itemization -->
		<div id="invoice_itemization">
			<h2>Itemization</h2>
			<table>
				<thead>
					<tr>
{if ($invoice.type_id == 2) || ($invoice.type_id == 3) }
						<th class="qty">{$LANG.quantity_short}</th>
						<th class="item">{$LANG.item}</th>
						<th class="price-unit">Unit</th>
						<th class="price-item">Total</th>
{/if}
{if $invoice.type_id == 1 }
						<th class="description" colspan="4">{$LANG.description}</th>
{/if}
					</tr>
				</thead>
				
				<tfoot></tfoot>
				
				<tbody>
{* Invoice Type 2 or Type 3 - Itemized, formerly Type 2 and 3 were the same info merely displayed in slightly different order *}
{if ($invoice.type_id == 2) || ($invoice.type_id == 3) }
	{foreach from=$invoiceItems item=invoiceItem}
					<tr>
						<td class="qty number">{$invoiceItem.quantity|siLocal_number_trim}</td>
						<td class="item">
							<span class="item-title">{$invoiceItem.product.description|htmlsafe}</span>
		{if $invoiceItem.description != null}
							<span class="item-detail"><span>{$invoiceItem.description|htmlsafe}</span></span>
		{/if}
		{if $invoiceItem.product.custom_field1 != null}
							<span class="item-custom-field"><span class="desc">{$customFieldLabels.product_cf1}: </span><span>{$invoiceItem.product.custom_field1|htmlsafe}</span></span>
		{/if}
		{if $invoiceItem.product.custom_field2 != null}
							<span class="item-custom-field"><span class="desc">{$customFieldLabels.product_cf2}: </span><span>{$invoiceItem.product.custom_field2|htmlsafe}</span></span>
		{/if}
		{if $invoiceItem.product.custom_field3 != null}
							<span class="item-custom-field"><span class="desc">{$customFieldLabels.product_cf3}: </span><span>{$invoiceItem.product.custom_field3|htmlsafe}</span></span>
		{/if}
		{if $invoiceItem.product.custom_field4 != null}
							<span class="item-custom-field"><span class="desc">{$customFieldLabels.product_cf4}: </span><span>{$invoiceItem.product.custom_field4|htmlsafe}</span></span>
		{/if}
						</td>
						<td class="price-unit number">{$preference.pref_currency_sign|htmlsafe}{$invoiceItem.unit_price|siLocal_number}</td>
						<td class="price-item number">{$preference.pref_currency_sign|htmlsafe}{$invoiceItem.gross_total|siLocal_number}</td>
					</tr>
	{/foreach}
{/if}


{* Invoice Type 1 - Total, No Itemization *}
{if $invoice.type_id == 1 }
		{foreach from=$invoiceItems item=invoiceItem}
					<tr>
						<td class="description" colspan="4">{$invoiceItem.description|outhtml}</td>
					</tr>
		{/foreach}
{/if}
				</tbody>
			</table>
		</div>



<!-- Totals -->
		<div id="invoice_totals">
			<h2>Totals</h2>
			<table>
{if $invoice_number_of_taxes > 0 }
				<tr class="subtotal{if $invoice_number_of_taxes > 1} underline{/if}">
					<td class="desc">{$LANG.sub_total}:</td>
					<td class="price"><span class="number">{$preference.pref_currency_sign|htmlsafe}{$invoice.gross|siLocal_number}</span></td>
				</tr>
{/if}
{section name=line start=0 loop=$invoice.tax_grouped step=1}
	{if ($invoice.tax_grouped[line].tax_amount != "0") }
				<tr class="tax">
					<td class="desc">{$invoice.tax_grouped[line].tax_name|htmlsafe}:</td>
					<td class="price"><span class="number">{$preference.pref_currency_sign|htmlsafe}{$invoice.tax_grouped[line].tax_amount|siLocal_number}</span></td>
				</tr>
	{/if}
{/section}
{if $invoice_number_of_taxes > 1}
				<tr class="tax tax-total">
					<td class="desc">{$LANG.tax_total}:</td>
					<td class="price"><span class="number">{$preference.pref_currency_sign|htmlsafe}{$invoice.total_tax|siLocal_number}</span></td>
				</tr>
{/if}
				<tr class="total">
					<td class="desc">{$preference.pref_inv_wording|htmlsafe} {$LANG.amount}:</td>
					<td class="price"><strong class="number">{$preference.pref_currency_sign|htmlsafe}{$invoice.total|siLocal_number}</strong></td>
				</tr>
			</table>
		</div>


{if ($invoice.type_id == 2 && $invoice.note != "") || ($invoice.type_id == 3 && $invoice.note != "") }
<!-- Notes -->
		<div id="invoice_notes">
			<h2>{$LANG.notes}</h2>
			<p>{$invoice.note|outhtml}</p>
		</div>
{/if}


<!-- Details -->
		<div id="invoice_details">
			<h2>{$preference.pref_inv_detail_heading|htmlsafe}</h2>
			<p>{$preference.pref_inv_detail_line|outhtml}</p>
			
			<h3>Accepted Payments</h3>
			<ul id="payments">
{if $preference.pref_inv_payment_method != ""}
				<li>{$preference.pref_inv_payment_method|htmlsafe}
	{if $preference.pref_inv_payment_line1_name != ""}
					<ul>
						<li><span class="desc">{$preference.pref_inv_payment_line1_name|htmlsafe}: </span><span>{$preference.pref_inv_payment_line1_value|htmlsafe}</span></li>
		{if $preference.pref_inv_payment_line2_name != ""}
						<li><span class="desc">{$preference.pref_inv_payment_line2_name|htmlsafe}: </span><span>{$preference.pref_inv_payment_line2_value|htmlsafe}</span></li>
		{/if}
					</ul>
	{/if}
				</li>
{/if}
{if $preference.include_online_payment == "paypal"}
				<li>PayPal {online_payment_link 
				type=$preference.include_online_payment business=$biller.paypal_business_name 
				item_name=$invoice.index_name invoice=$invoice.id 
				amount=$invoice.total currency_code=$preference.currency_code
				link_wording=$LANG.paypal_link
				notify_url=$biller.paypal_notify_url return_url=$biller.paypal_return_url
				domain_id = $invoice.domain_id include_image=true}</li>
{/if}
{if $preference.include_online_payment == "eway_merchant_xml"}
				<li>eWay Merchant</li>
{/if}
			</ul>
		</div>
	</div>

	<div id="footer">{$biller.footer|outhtml}</div>
</div>
</body>
</html>
