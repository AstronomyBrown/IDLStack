/**
 * SelectType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.2beta Mar 31, 2004 (12:47:03 EST) WSDL2Java emitter.
 */

package net.ivoa.www.xml.ADQL.v0_7_4;

public class SelectType  implements java.io.Serializable {
    private net.ivoa.www.xml.ADQL.v0_7_4.SelectionOptionType allow;
    private net.ivoa.www.xml.ADQL.v0_7_4.SelectionLimitType restrict;
    private net.ivoa.www.xml.ADQL.v0_7_4.SelectionListType selectionList;
    private net.ivoa.www.xml.ADQL.v0_7_4.FromType from;
    private net.ivoa.www.xml.ADQL.v0_7_4.WhereType where;
    private net.ivoa.www.xml.ADQL.v0_7_4.GroupByType groupBy;
    private net.ivoa.www.xml.ADQL.v0_7_4.HavingType having;
    private net.ivoa.www.xml.ADQL.v0_7_4.OrderExpressionType orderBy;

    public SelectType() {
    }


    /**
     * Gets the allow value for this SelectType.
     * 
     * @return allow
     */
    public net.ivoa.www.xml.ADQL.v0_7_4.SelectionOptionType getAllow() {
        return allow;
    }


    /**
     * Sets the allow value for this SelectType.
     * 
     * @param allow
     */
    public void setAllow(net.ivoa.www.xml.ADQL.v0_7_4.SelectionOptionType allow) {
        this.allow = allow;
    }


    /**
     * Gets the restrict value for this SelectType.
     * 
     * @return restrict
     */
    public net.ivoa.www.xml.ADQL.v0_7_4.SelectionLimitType getRestrict() {
        return restrict;
    }


    /**
     * Sets the restrict value for this SelectType.
     * 
     * @param restrict
     */
    public void setRestrict(net.ivoa.www.xml.ADQL.v0_7_4.SelectionLimitType restrict) {
        this.restrict = restrict;
    }


    /**
     * Gets the selectionList value for this SelectType.
     * 
     * @return selectionList
     */
    public net.ivoa.www.xml.ADQL.v0_7_4.SelectionListType getSelectionList() {
        return selectionList;
    }


    /**
     * Sets the selectionList value for this SelectType.
     * 
     * @param selectionList
     */
    public void setSelectionList(net.ivoa.www.xml.ADQL.v0_7_4.SelectionListType selectionList) {
        this.selectionList = selectionList;
    }


    /**
     * Gets the from value for this SelectType.
     * 
     * @return from
     */
    public net.ivoa.www.xml.ADQL.v0_7_4.FromType getFrom() {
        return from;
    }


    /**
     * Sets the from value for this SelectType.
     * 
     * @param from
     */
    public void setFrom(net.ivoa.www.xml.ADQL.v0_7_4.FromType from) {
        this.from = from;
    }


    /**
     * Gets the where value for this SelectType.
     * 
     * @return where
     */
    public net.ivoa.www.xml.ADQL.v0_7_4.WhereType getWhere() {
        return where;
    }


    /**
     * Sets the where value for this SelectType.
     * 
     * @param where
     */
    public void setWhere(net.ivoa.www.xml.ADQL.v0_7_4.WhereType where) {
        this.where = where;
    }


    /**
     * Gets the groupBy value for this SelectType.
     * 
     * @return groupBy
     */
    public net.ivoa.www.xml.ADQL.v0_7_4.GroupByType getGroupBy() {
        return groupBy;
    }


    /**
     * Sets the groupBy value for this SelectType.
     * 
     * @param groupBy
     */
    public void setGroupBy(net.ivoa.www.xml.ADQL.v0_7_4.GroupByType groupBy) {
        this.groupBy = groupBy;
    }


    /**
     * Gets the having value for this SelectType.
     * 
     * @return having
     */
    public net.ivoa.www.xml.ADQL.v0_7_4.HavingType getHaving() {
        return having;
    }


    /**
     * Sets the having value for this SelectType.
     * 
     * @param having
     */
    public void setHaving(net.ivoa.www.xml.ADQL.v0_7_4.HavingType having) {
        this.having = having;
    }


    /**
     * Gets the orderBy value for this SelectType.
     * 
     * @return orderBy
     */
    public net.ivoa.www.xml.ADQL.v0_7_4.OrderExpressionType getOrderBy() {
        return orderBy;
    }


    /**
     * Sets the orderBy value for this SelectType.
     * 
     * @param orderBy
     */
    public void setOrderBy(net.ivoa.www.xml.ADQL.v0_7_4.OrderExpressionType orderBy) {
        this.orderBy = orderBy;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof SelectType)) return false;
        SelectType other = (SelectType) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.allow==null && other.getAllow()==null) || 
             (this.allow!=null &&
              this.allow.equals(other.getAllow()))) &&
            ((this.restrict==null && other.getRestrict()==null) || 
             (this.restrict!=null &&
              this.restrict.equals(other.getRestrict()))) &&
            ((this.selectionList==null && other.getSelectionList()==null) || 
             (this.selectionList!=null &&
              this.selectionList.equals(other.getSelectionList()))) &&
            ((this.from==null && other.getFrom()==null) || 
             (this.from!=null &&
              this.from.equals(other.getFrom()))) &&
            ((this.where==null && other.getWhere()==null) || 
             (this.where!=null &&
              this.where.equals(other.getWhere()))) &&
            ((this.groupBy==null && other.getGroupBy()==null) || 
             (this.groupBy!=null &&
              this.groupBy.equals(other.getGroupBy()))) &&
            ((this.having==null && other.getHaving()==null) || 
             (this.having!=null &&
              this.having.equals(other.getHaving()))) &&
            ((this.orderBy==null && other.getOrderBy()==null) || 
             (this.orderBy!=null &&
              this.orderBy.equals(other.getOrderBy())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = 1;
        if (getAllow() != null) {
            _hashCode += getAllow().hashCode();
        }
        if (getRestrict() != null) {
            _hashCode += getRestrict().hashCode();
        }
        if (getSelectionList() != null) {
            _hashCode += getSelectionList().hashCode();
        }
        if (getFrom() != null) {
            _hashCode += getFrom().hashCode();
        }
        if (getWhere() != null) {
            _hashCode += getWhere().hashCode();
        }
        if (getGroupBy() != null) {
            _hashCode += getGroupBy().hashCode();
        }
        if (getHaving() != null) {
            _hashCode += getHaving().hashCode();
        }
        if (getOrderBy() != null) {
            _hashCode += getOrderBy().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(SelectType.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "selectType"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("allow");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "Allow"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "selectionOptionType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("restrict");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "Restrict"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "selectionLimitType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("selectionList");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "SelectionList"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "selectionListType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("from");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "From"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "fromType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("where");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "Where"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "whereType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("groupBy");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "GroupBy"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "groupByType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("having");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "Having"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "havingType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("orderBy");
        elemField.setXmlName(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "OrderBy"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.ivoa.net/xml/ADQL/v0.7.4", "orderExpressionType"));
        elemField.setMinOccurs(0);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
